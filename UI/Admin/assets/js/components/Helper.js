import GraphData from "./chartjs";

import {
    format,
    compareDesc,
    startOfDay,
    endOfDay,
    startOfYesterday,
    endOfYesterday,
    subDays,
    subHours,
    subMonths,
    isYesterday,
    isToday,
} from "date-fns";

const Helper = {
    init() { },

    removeWhmcsDevLicense() {
        var license = $("strong:contains('Dev License:')");
        if (license.length && license.parents().length) {
            $("strong:contains('Dev License:')")
                .parents()[0]
                .remove();
        }
        $("a[href='https://www.whmcs.com/']:contains('WHMCompleteSolution')")
            .parents("p")
            .remove();
    },

    //
    initTableData(
        el,
        localStorageKey,
        dataTable,
        serviceid,
    ) {
        return new Vue({
            delimiters: ["[[", "]]"],
            el: el,
            data: {
                tablename: el,
                localStorageKey: localStorageKey,

                // Pagination define
                maxVisibleButtons: 50,
                totalPages: 1,
                totalItems: 0,
                perPage: 10,
                currentPage: 1,
                allItems: [],
                range: [],

                serviceid: serviceid,
                dataTable: dataTable,
                modalTarget: 'addDomain',
                alertMsg: '',

                addDomain: '',
                addBackend: '',
                addForcessl: '',
                addSSLMode: '',

                editDomain: '',
                editBackend: '',
                editForcessl: '',
                editSSLMode: '',

                selectedDomain: '',
                selectedSSLMode: '',
                selectedSSLType: '',

                loading: false,
            },

            computed: {
                pages() {
                    return this.dataTable.slice((this.currentPage - 1) * this.perPage, (this.currentPage - 1) * this.perPage + this.perPage)
                }
            },

            watch: {
                currentPage() {
                    this.range = [];
                    this.range = this.getPagination(this.currentPage, this.totalPages);
                },
                dataTable() {
                    this.totalPages = Math.round(Math.ceil(((this.dataTable.length)) / this.perPage)); // :2 IF HAVE MOBILE MODE

                    if (this.currentPage > this.totalPages) {
                        this.currentPage = this.totalPages;
                    }

                    this.range = this.getPagination(this.currentPage, this.totalPages);
                }
            },

            mounted() {
                this.handlePagination();
            },

            methods: {
                // Init pagination data
                handlePagination() {
                    this.initPaginationData();
                    this.changePage();
                },

                initPaginationData() {
                    // reset pagination data
                    if (this.range.length) {
                        this.currentPage = 1;
                        this.range = [];
                    }
                    if (this.allItems.length) {
                        this.allItems = [];
                    }

                    if (this.dataTable.length > 0) {
                        this.totalPages = Math.round(Math.ceil(((this.dataTable.length)) / this.perPage)); // :2 IF HAVE MOBILE MODE
                    }

                    this.range = this.getPagination(this.currentPage, this.totalPages);
                },

                changePage() {
                    // Validate page
                    if (this.currentPage < 1) {
                        this.currentPage = 1;
                    }

                    if (this.totalPages > 0 && this.currentPage > this.totalPages) {
                        this.currentPage = this.totalPages;
                    }
                },

                onClickPreviousPage() {
                    if (this.currentPage > 1) {
                        this.currentPage--;
                        this.changePage();
                    }
                },

                onClickPage(page) {
                    if (this.currentPage != page && typeof page == "number") {
                        this.currentPage = page;
                        this.changePage();
                    }
                },

                onClickNextPage() {
                    if (this.currentPage < this.totalPages) {
                        this.currentPage++;
                        this.changePage();
                    }
                },

                setCurrentPagesTyle(page) {
                    return this.currentPage == page ?
                        "background-color: #38A7FF !important; color: #ffffff !important;" :
                        "";
                },

                getPagination(currentPage, pageCount) {
                    if (!currentPage && !pageCount) {
                        return [];
                    }
                    const delta = 2;
                    const left = currentPage - delta;
                    const right = currentPage + delta + 1;
                    let result = [];

                    result = Array.from({ length: pageCount }, (v, k) => k + 1).filter(
                        (i) => i && i >= left && i < right
                    );

                    if (result.length > 1) {
                        // Add first page and dots
                        if (result[0] > 1) {
                            if (result[0] > 2) {
                                result.unshift("...");
                            }
                            result.unshift(1);
                        }

                        // Add dots and last page
                        if (result[result.length - 1] < pageCount) {
                            if (result[result.length - 1] !== pageCount - 1) {
                                result.push("...");
                            }
                            result.push(pageCount);
                        }
                    }

                    return result;
                },

                handleAddDomain() {

                    if (!this.addDomain || !this.addBackend) {
                        this.alertMsg = 'Vui lòng nhập đầy đủ thông tin Domain và Backend';
                        $('#submit-add-domain').removeAttr('disabled');
                        return;
                    }

                    this.loading = true;

                    var reqstr = "clientsservices.php?action=productdetails&id=" + this.serviceid + "&modop=custom&ac=admin_config_domain&token=" + $("input[name=token]:first").val();

                    var payload = { cmd: 'add_domain', fw_domain: this.addDomain, backend: this.addBackend, sslmode: this.addSSLMode, forcessl: this.addSSLmode }

                    $.post(reqstr, payload,
                        (data) => {
                            if (data?.success) {
                                $("#configDomainModal").modal("hide");

                                this.dataTable.push({
                                    "vhost": this.addDomain,
                                    "fwip": '',
                                    "origin": `http://${this.addBackend}`,
                                    "sslredirect": "no data",
                                    "sslmode": "no data"
                                })

                            } else {
                                this.alertMsg = data.result?.messages?.join(' ') || 'Có lỗi xảy ra, vui lòng thử lại'
                            }
                        },
                        "json"
                    ).always(() => {
                        this.loading = false;
                    });
                },

                handleEditDomain() {

                    if (!this.addDomain || !this.addBackend) {
                        this.alertMsg = 'Vui lòng nhập đầy đủ thông tin Domain và Backend';
                        $('#adminBtnEditDomain').removeAttr('disabled');
                        return;
                    }

                    this.loading = true;

                    var reqstr = "clientsservices.php?action=productdetails&id=" + this.serviceid + "&modop=custom&ac=admin_config_domain&token=" + $("input[name=token]:first").val();

                    var payload = { cmd: 'edit_domain', fw_domain: this.addDomain, backend: this.addBackend, sslmode: this.addSSLMode, forcessl: this.addSSLmode }

                    $.post(reqstr, payload,
                        (data) => {
                            if (data?.success) {
                                $("#configDomainModal").modal("hide");

                                this.dataTable.push({
                                    "vhost": this.addDomain,
                                    "fwip": '',
                                    "origin": `http://${this.addBackend}`,
                                    "sslredirect": "no data",
                                    "sslmode": "no data"
                                })

                            } else {
                                this.alertMsg = data.result?.messages?.join(' ') || 'Có lỗi xảy ra, vui lòng thử lại'
                            }
                        },
                        "json"
                    ).always(() => {
                        this.loading = false;
                    });
                },

                handleDeleteDomain() {
                    this.loading = true;

                    var reqstr = "clientsservices.php?action=productdetails&id=" + this.serviceid + "&modop=custom&ac=admin_config_domain&token=" + $("input[name=token]:first").val();

                    var payload = { cmd: 'delete_domain', fw_domain: this.selectedDomain }

                    $.post(reqstr, payload,
                        (data) => {
                            if (data?.success) {
                                const index = this.dataTable.findIndex((item) => item.vhost === this.selectedDomain)

                                if (index >= 0) {
                                    this.dataTable.splice(index, 1)
                                }

                                $("#configDomainModal").modal("hide");
                            }
                        },
                        "json"
                    ).always(() => {
                        this.loading = false;
                    });
                },

                fillContentModalEditDomain() {
                    var selectedRow = this.dataTable.find((item) => item.vhost === this.selectedDomain)

                    if (selectedRow) {
                        this.editDomain = selectedRow.vhost;
                        this.editBackend = selectedRow.origin;
                        this.editForcessl = selectedRow.sslredirect;
                        this.editSSLMode = selectedRow.sslmode;
                    }
                },

                resetModalContent() {
                    /// reset modal add domain ///
                    this.addDomain = ''
                    this.addBackend = ''
                    this.addForcessl = false
                    this.addSSLMode = ''
                    this.alertMsg = ''

                    /// reset modal edit domain ///

                    this.editDomain = ''
                    this.editBackend = ''
                    this.editForcessl = false
                    this.editSSLMode = ''

                    /// reset selected ///
                    this.selectedDomain = ''
                    this.selectedSSLMode = ''
                    this.selectedSSLType = ''

                    this.loading = false
                }
                //**********************
            },
            //******
        });
    },
    //******

    initGraphData(sid, regdate, ipfw) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var gte = startOfDay(new Date());
            var lte = endOfDay(new Date());
            var rdate = new Date(my_date(regdate)).toISOString();
            var now = new Date().toISOString();

            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();
            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), ipfw: ipfw }, function (respone) {
                var gdata = JSON.parse(respone);
                GraphData.update_chart_data(gdata);
            });

            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();
            $.post(reqstr, { gte: rdate, lte: now, ipfw: ipfw, cmd: 'get_data_transfer' }, function (respone) {
                var gdata = JSON.parse(respone);
                $('#fw-data-transfer').html(gdata);
            });
        });
    },

    initGraphDetail(sid, ipfw) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var chart = new Vue({
                delimiters: ["[[", "]]"],
                el: '#fw-graph-detail',
                data: {
                    filterdatestart: '',
                    filterdateend: '',
                    timerange: '3hourago',
                    domain: 'all',
                },
                mounted() {
                    this.fillRangePicker(this.timerange);
                },
                watch: {
                    timerange(rangepicker) {
                        this.fillRangePicker(rangepicker, this.domain);
                    },
                    domain(domain) {
                        this.fillRangePicker(this.timerange, domain);
                    }
                },
                methods: {
                    fillRangePicker(rangepicker, domain = 'all') {
                        if (rangepicker) {
                            var formatDate = "yyyy-MM-dd";
                            var gte = '';
                            var lte = '';

                            if (rangepicker == "3hourago") {
                                gte = subHours(new Date(), 3);
                                lte = new Date();
                            } else if (rangepicker == "6hourago") {
                                gte = subHours(new Date(), 6);
                                lte = new Date();
                            } else if (rangepicker == "12hourago") {
                                gte = subHours(new Date(), 12);
                                lte = new Date();
                            } else if (rangepicker == "24hourago") {
                                gte = subHours(new Date(), 24);
                                lte = new Date();
                            }

                            this.filterdatestart = format(gte, formatDate);
                            this.filterdateend = format(lte, formatDate);
                            this.domain = domain;

                            var reqstr = "clientsservices.php?action=productdetails&id=" + sid + "&modop=custom&ac=view_graph&token=" + $("input[name=token]:first").val();

                            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), domain: domain, ipfw: ipfw }, (respone) => {
                                var gdata = JSON.parse(respone);
                                GraphData.update_chart_data(gdata);
                            });
                        }
                    },
                }
            });
        });
    },

    initLogsDetail(sid, ipfw) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var logs = new Vue({
                delimiters: ["[[", "]]"],
                el: '#vnx-fwlogs-table',
                data: {
                    filterdatestart: '',
                    filterdateend: '',
                    timerange: '3hourago',
                    domain: 'all',
                    logData: ''
                },
                mounted() {
                    this.fillRangePicker(this.timerange);
                },

                watch: {
                    timerange(rangepicker) {
                        this.fillRangePicker(rangepicker, this.domain);
                    },
                    domain(domain) {
                        this.fillRangePicker(this.timerange, domain);
                    }
                },
                methods: {
                    fillRangePicker(rangepicker, domain = 'all') {
                        if (rangepicker) {
                            var formatDate = "yyyy-MM-dd";
                            var gte = '';
                            var lte = '';

                            if (rangepicker == "3hourago") {
                                gte = subHours(new Date(), 3);
                                lte = new Date();
                            } else if (rangepicker == "6hourago") {
                                gte = subHours(new Date(), 6);
                                lte = new Date();
                            } else if (rangepicker == "12hourago") {
                                gte = subHours(new Date(), 12);
                                lte = new Date();
                            } else if (rangepicker == "24hourago") {
                                gte = subHours(new Date(), 24);
                                lte = new Date();
                            }

                            this.filterdatestart = format(gte, formatDate);
                            this.filterdateend = format(lte, formatDate);
                            this.domain = domain;

                            var reqstr = "clientsservices.php?action=productdetails&id=" + sid + "&modop=custom&ac=view_logs&token=" + $("input[name=token]:first").val();

                            this.logData = ''

                            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), ipfw: ipfw, domain: domain, cmd: 'get_logs' }, (respone) => {
                                var gdata = JSON.parse(respone);
                                if (!gdata) {
                                    this.logData = 'none';
                                } else {
                                    this.logData = gdata;
                                }
                            });
                        }

                    }
                }

            });
        });
    }
};
export default Helper;

function my_date(date_string) {
    var date_components = date_string.split("/");
    var day = date_components[0];
    var month = date_components[1];
    var year = date_components[2];
    return new Date(year, month - 1, day);
}
