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
    init(el, localStorageKey, dataTable, serviceid) {
        var app = new Vue({
            delimiters: ["[[", "]]"],
            el: el,
            data: {
                tablename: el,
                localStorageKey: localStorageKey,
                maxVisibleButtons: 50,
                totalPages: 0,
                totalItems: 0,
                perPage: 10,
                currentPage: 1,
                allItems: [],
                range: [],
                serviceid: serviceid,
                dataTable: dataTable,
                modalTarget: 'addDomain',

                selectedDomain: '',
                selectedSSLMode: '',
                selectedSSLType: '',

                addDomain: '',
                addBackend: '',
                addSSLMode: 'none',
                addForceSSL: '',
                addCustomSSL: '',
                addCert: '',
                addKey: '',
                addCA: '',

                editDomain: '',
                editBackend: '',
                editForceSSL: '',
                editSSLMode: '',
                editSSLStatus: '',
                editCustomSSL: '',
                editCert: '',
                editKey: '',
                editCA: '',
                editStartDate: '',
                editEndDate: '',

                alert: '',
                alertMsg: '',
                alertType: '',
                alertPosition: '',
                loading: false
            },
            computed: {
                pages() {
                    return this.dataTable.slice((this.currentPage - 1) * this.perPage, (this.currentPage - 1) * this.perPage + this.perPage)
                }
            },
            watch: {
                currentPage() {
                    this.range = this.getPagination(this.currentPage, this.totalPages);
                },
                dataTable() {
                    this.initPaginationData();
                }
            },
            mounted() {
                document.onkeydown = function (evt) {
                    evt = evt || window.event;
                    var isEscape = false;
                    if ("key" in evt) {
                        isEscape = evt.key === "Escape" || evt.key === "Esc";
                    } else {
                        isEscape = evt.isEscape;
                    }
                    app.hideAllModal(isEscape);
                }
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

                toggleModal(modalID) {
                    const modal = document.querySelector("#" + modalID);
                    modal.classList.toggle("opacity-0");
                    modal.classList.toggle("pointer-events-none");
                    modal.classList.toggle("vf-opacity-0");

                    if (!modal.classList.contains("vf-opacity-0")) {
                        modal.style.display = "flex";
                    } else {
                        modal.style.display = "none";
                    }

                    const body = document.querySelector(".vnx-main");

                    if (!modal.classList.contains("vf-opacity-0")) {
                        body.style.overflow = "hidden";
                    } else {
                        body.style.overflow = "auto";
                    }
                },

                hideAllModal(isEscape) {
                    let modalAddDomain = document.querySelector("#modalAddDomain");
                    if (isEscape && !modalAddDomain.classList.contains("vf-opacity-0")) {
                        this.toggleModal('modalAddDomain');
                    }
                    let modalEditDomain = document.querySelector("#modalEditDomain");
                    if (isEscape && !modalEditDomain.classList.contains("vf-opacity-0")) {
                        this.toggleModal('modalEditDomain');
                    }
                    let modalConfirmDelete = document.querySelector("#modalConfirmDelete");
                    if (isEscape && !modalConfirmDelete.classList.contains("vf-opacity-0")) {
                        this.toggleModal('modalConfirmDelete');
                    }
                },

                handleOnOffDomain() {
                    var _this = this;

                    var domain = this.dataTable.find(function (item) {
                        return item.vhost === _this.selectedDomain;
                    });

                    var statusSet = domain.enable ? 'turn_off' : 'turn_on';
                    this.loading = true;

                    var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&modop=custom&a=config_domain&token=" + $("input[name=token]:first").val();
                    var payload = {
                        cmd: 'on_off_domain',
                        domain: domain.vhost,
                        status: statusSet
                    };
                    $.post(reqstr, payload, function (data) {
                        if (data !== null && data !== void 0 && data.success) {
                            var index = _this.dataTable.findIndex(function (item) {
                                return item.vhost === domain.vhost;
                            });
                            if (statusSet == 'turn_off') {
                                _this.$set(_this.dataTable[index], 'enable', false);
                                app.alertMsg = "Domain " + domain.vhost + " đã TẮT";
                                app.alertType = 'warning';
                                app.alertPosition = 'list';
                            }
                            else if (statusSet == 'turn_on') {
                                _this.$set(_this.dataTable[index], 'enable', true);
                                app.alertMsg = "Domain " + domain.vhost + " đã BẬT";
                                app.alertType = 'success';
                                app.alertPosition = 'list';
                            }
                        } else {
                            app.alertMsg = data.result?.messages?.join(' ') || "Đã xảy ra lỗi, vui lòng thử lại.";
                            app.alertType = 'error';
                            app.alertPosition = 'list';
                        }
                    }, "json").always(function () {
                        _this.loading = false;
                    });
                },

                handleAddDomain() {
                    var _this = this;
                    if (!this.addDomain || !this.addBackend) {
                        this.alertMsg = (!this.addDomain ? 'Domain' : 'Backend') + ' là trường bắt buộc';
                        this.alertType = 'error';
                        this.alertPosition = 'add_popup';
                    }
                    else if (!this.validateDomain(this.addDomain.trim())) {
                        this.alertMsg = 'Tên miền không hợp lệ, vui lòng thử lại';
                        this.alertType = 'error';
                        this.alertPosition = 'add_popup';
                    }
                    else if (!this.validateIPaddress(this.addBackend.trim())) {
                        this.alertMsg = 'Backend không hợp lệ, vui lòng thử lại';
                        this.alertType = 'error';
                        this.alertPosition = 'add_popup';
                    }
                    else {
                        this.loading = true;
                        var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&modop=custom&a=config_domain&token=" + $("input[name=token]:first").val();
                        var payload = {
                            cmd: 'add_domain',
                            domain: this.addDomain.trim(),
                            backend: this.addBackend.trim(),
                            sslmode: this.addSSLMode,
                            forcessl: this.addForceSSL,
                            customssl: this.addCustomSSL,
                            cert: this.addCert,
                            key: this.addKey,
                            ca: this.addCA
                        };

                        $.post(reqstr, payload, function (data) {
                            if (data !== null && data !== void 0 && data.success) {
                                var vhost = data.data;
                                _this.dataTable.push({
                                    "vhost": vhost.vhost[0],
                                    "enable": vhost.enable,
                                    "fwIP": vhost.fwIP,
                                    "beIP": vhost.beIP,
                                    "sslMode": vhost.sslMode,
                                    "customSSL": vhost.customSSL,
                                    "forceSSL": vhost.forceSSL,
                                    "cert": vhost.cert,
                                    "key": vhost.key,
                                    "sslStatus": vhost.sslStatus,
                                    "sslStartDate": vhost.sslStartDate,
                                    "sslEndDate": vhost.sslEndDate,
                                });
                                app.alertMsg = data.result?.messages?.join(' ') || "Thêm domain " + _this.addDomain + " thành công";
                                app.alertType = 'success';
                                app.alertPosition = 'list';

                                _this.toggleModal('modalAddDomain');
                            } else {
                                if (data.errors[0] == 'DOMAIN_NOT_POINTED_TO_FIREWALL') {
                                    app.alertMsg = 'Lỗi khởi tạo domain SSL, domain ' + _this.addDomain + ' không được trỏ về Firewall này.';
                                }
                                else {
                                    app.alertMsg = data.result?.details[0] || "Đã xảy ra lỗi, vui lòng thử lại.";
                                }
                                app.alertType = 'error';
                                app.alertPosition = 'add_popup';
                            }
                        }, "json").always(function (res) {
                            _this.loading = false;
                        });
                    }
                },

                handleEditDomain() {
                    var _this = this;
                    $('#btnEditDomain').attr('disabled', 'disabled');
                    if (!this.editDomain || !this.editBackend) {
                        this.alertMsg = 'Vui lòng nhập thông tin Backend';
                        this.alertType = 'error';
                        this.alertPosition = 'edit_popup';
                        $('#btnEditDomain').removeAttr('disabled');
                        return;
                    }
                    else if (!this.validateDomain(this.editDomain.trim())) {
                        this.alertMsg = 'Tên miền không hợp lệ, vui lòng thử lại';
                        this.alertType = 'error';
                        this.alertPosition = 'edit_popup';
                        $('#btnEditDomain').removeAttr('disabled');
                        return;
                    }
                    else if (!this.validateIPaddress(this.editBackend.trim())) {
                        this.alertMsg = 'Backend không hợp lệ, vui lòng thử lại';
                        this.alertType = 'error';
                        this.alertPosition = 'edit_popup';
                        $('#btnEditDomain').removeAttr('disabled');
                        return;
                    }
                    this.loading = true;

                    var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&modop=custom&a=config_domain&token=" + $("input[name=token]:first").val();
                    var payload = {
                        cmd: 'update_domain',
                        domain: this.editDomain.trim(),
                        backend: this.editBackend.trim(),
                        sslmode: this.editSSLMode,
                        forcessl: this.editForceSSL,
                        customssl: this.editCustomSSL,
                        cert: this.editCert,
                        key: this.editKey,
                        ca: this.editCA
                    };

                    $.post(reqstr, payload, function (data) {
                        if (data !== null && data !== void 0 && data.success) {
                            var vhost = data.data;
                            var index = _this.dataTable.findIndex(function (item) {
                                return item.vhost === _this.editDomain;
                            });

                            _this.$set(_this.dataTable[index], 'vhost', vhost.vhost[0]);
                            _this.$set(_this.dataTable[index], 'enable', vhost.enable);
                            _this.$set(_this.dataTable[index], 'fwIP', vhost.fwIP);
                            _this.$set(_this.dataTable[index], 'beIP', vhost.beIP);
                            _this.$set(_this.dataTable[index], 'sslMode', vhost.sslMode);
                            _this.$set(_this.dataTable[index], 'customSSL', vhost.customSSL);
                            _this.$set(_this.dataTable[index], 'forceSSL', vhost.forceSSL);
                            _this.$set(_this.dataTable[index], 'cert', vhost.cert);
                            _this.$set(_this.dataTable[index], 'key', vhost.key);
                            _this.$set(_this.dataTable[index], 'sslStatus', vhost.sslStatus);
                            _this.$set(_this.dataTable[index], 'sslStartDate', vhost.sslStartDate);
                            _this.$set(_this.dataTable[index], 'sslEndDate', vhost.sslEndDate);

                            app.alertMsg = data.result?.messages?.join(' ') || "Cập nhật domain " + _this.editDomain + " thành công";
                            app.alertType = 'success';
                            app.alertPosition = 'list';

                            _this.toggleModal('modalEditDomain');
                        } else {
                            if (data.errors[0] == 'DOMAIN_NOT_POINTED_TO_FIREWALL') {
                                _this.alertMsg = 'Lỗi cập nhật domain SSL, domain ' + _this.editDomain + ' không được trỏ về Firewall này.';
                            }
                            else {
                                _this.alertMsg = data.result?.details[0] || "Đã xảy ra lỗi, vui lòng thử lại.";
                            }
                            _this.alertType = 'error';
                            _this.alertPosition = 'edit_popup';
                        }
                    }, "json").always(function () {
                        _this.loading = false;
                    });
                },

                fillContentModalEditDomain() {
                    var _this5 = this;
                    var selectedRow = this.dataTable.find(function (item) {
                        return item.vhost === _this5.selectedDomain;
                    });

                    if (selectedRow) {
                        var certString = atob(selectedRow.cert);
                        var regexSplitCert = /-----BEGIN CERTIFICATE-----(.*?)-----END CERTIFICATE-----/gs,
                            certArray = certString.match(regexSplitCert);
                        if (certArray) {
                            var crt = certArray.length > 0 ? certArray.shift() : '',
                                ca = certArray.length > 0 ? certArray.join('\n') : '';
                        }

                        this.editDomain = selectedRow.vhost;
                        this.editBackend = selectedRow.beIP;
                        this.editForceSSL = selectedRow.forceSSL == 'yes' ? true : false;
                        this.editCustomSSL = selectedRow.customSSL == 'yes' ? 'upload' : '';
                        this.editSSLMode = selectedRow.sslMode;
                        this.editCert = selectedRow.sslMode != 'none' ? crt : '';
                        this.editKey = selectedRow.sslMode != 'none' ? atob(selectedRow.key) : '';
                        this.editCA = selectedRow.sslMode != 'none' ? ca : '';
                        this.editStartDate = selectedRow.sslStartDate;
                        this.editEndDate = selectedRow.sslEndDate;
                        this.editSSLStatus = selectedRow.sslStatus;
                    }
                },

                handleDeleteDomain() {
                    var _this = this;
                    this.loading = true;
                    var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&modop=custom&a=config_domain&token=" + $("input[name=token]:first").val();
                    var payload = {
                        cmd: 'delete_domain',
                        domain: this.selectedDomain
                    };
                    $.post(reqstr, payload, function (data) {
                        if (data !== null && data !== void 0 && data.success) {
                            var index = _this.dataTable.findIndex(function (item) {
                                return item.vhost === _this.selectedDomain;
                            });
                            if (index >= 0) {
                                _this.dataTable.splice(index, 1);
                            }

                            app.alertMsg = data.result?.messages?.join(' ') || "Xoá domain " + _this.selectedDomain + " thành công";
                            app.alertType = 'success';
                            app.alertPosition = 'list';

                            _this.toggleModal('modalConfirmDelete');
                        }
                        else {
                            _this.alertMsg = 'Có lỗi xảy ra, vui lòng thử lại';
                            _this.alertType = 'error';
                            _this.alertPosition = 'delete_popup';
                        }
                    }, "json").always(function () {
                        _this.loading = false;
                    });
                },

                resetModalContent() {
                    /// reset modal add domain ///
                    this.addDomain = '';
                    this.addBackend = '';
                    this.addForceSSL = false;
                    this.addSSLMode = '';
                    this.alertMsg = '';

                    /// reset modal edit domain ///
                    this.editDomain = '';
                    this.editBackend = '';
                    this.editForceSSL = false;
                    this.editSSLMode = '';

                    /// reset selected ///
                    this.selectedDomain = '';
                    this.selectedSSLMode = '';
                    this.selectedSSLType = '';
                    this.loading = false;
                },

                copyToClipboard(element) {
                    var copyText = document.getElementById(element);
                    copyText.select();
                    document.execCommand("copy");

                    app.alertMsg = 'Đã sao chép vào clipboard thành công';
                    app.alertType = 'success';
                    app.alertPosition = 'edit_popup';
                },

                validateDomain(domain) {
                    if (/^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\.[a-zA-Z]{2,})+$/.test(domain)) {
                        return true
                    }
                    else {
                        return false;
                    }
                },

                validateIPaddress(ipaddress) {
                    const ipAddressRegex = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?::[0-9]{1,5})?$/;
                    if (ipAddressRegex.test(ipaddress)) {
                        return true;
                    }
                    return false;
                }
            },
        });
    },

    initOverviewData(sid, regdate, ipfw, serviceid) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var gte = startOfDay(new Date());
            var lte = endOfDay(new Date());
            var rdate = new Date(date_now(regdate)).toISOString();
            var now = new Date().toISOString();

            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();
            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), ipfw: ipfw }, function (respone) {
                var gdata = JSON.parse(respone);
                GraphData.update_chart_data(gdata);
            });

            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();
            $.post(reqstr, { gte: rdate, lte: now, ipfw: ipfw, sid: serviceid, cmd: 'get_data_transfer' }, function (respone) {
                var gdata = JSON.parse(respone);
                $('#fw-data-transfer').html(gdata);
            });

            var app = new Vue({
                delimiters: ["[[", "]]"],
                el: '#vnx-fw-overview',
                data: {
                    blockIpStatus: '',
                    ipfw: ipfw,
                    serviceid: serviceid,
                    loading: false,
                    alert: '',
                    alertMsg: '',
                    alertType: '',
                },
                computed: {},
                mounted() {
                    this.checkStatus();
                },

                methods: {
                    checkStatus() {
                        var _this = this;
                        _this.loading = true;
                        var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&token=" + $("input[name=token]:first").val();
                        var payload = {
                            cmd: 'check_block_ip',
                            ipfw: this.ipfw
                        };
                        $.post(reqstr, payload, function (data) {
                            if (data !== null && data !== void 0 && data.status == 0) {
                                _this.blockIpStatus = data.data;
                            }
                        }, "json").always(function () {
                            _this.loading = false;
                        });
                    },
                    setBlockIP() {
                        var _this = this;
                        _this.loading = true;
                        var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&token=" + $("input[name=token]:first").val();
                        var payload = {
                            cmd: 'set_block_ip',
                            ipfw: this.ipfw
                        };
                        $.post(reqstr, payload, function (data) {
                            if (data !== null && data !== void 0 && data.status == 0) {
                                _this.blockIpStatus = true;
                                _this.alertMsg = "Block IP International Successfully";
                                _this.alertType = 'success';
                            }
                        }, "json").always(function () {
                            _this.loading = false;
                        });
                    },
                    setUnblockIP() {
                        var _this = this;
                        _this.loading = true;
                        var reqstr = "clientarea.php?action=productdetails&id=" + this.serviceid + "&token=" + $("input[name=token]:first").val();
                        var payload = {
                            cmd: 'set_unblock_ip',
                            ipfw: this.ipfw
                        };
                        $.post(reqstr, payload, function (data) {
                            if (data !== null && data !== void 0 && data.status == 0) {
                                _this.blockIpStatus = false;
                                _this.alertMsg = "Unblock IP International Successfully";
                                _this.alertType = 'success';
                            }
                        }, "json").always(function () {
                            _this.loading = false;
                        });
                    },
                    toggleBlockIP(status) {
                        if (status == 'block') {
                            this.setBlockIP()
                        }
                        else if (status == 'unblock') {
                            this.setUnblockIP()
                        }
                    }
                }
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
                    domain: 'all'
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
                            }
                            else if (rangepicker == "12hourago") {
                                gte = subHours(new Date(), 12);
                                lte = new Date();
                            }
                            else if (rangepicker == "24hourago") {
                                gte = subHours(new Date(), 24);
                                lte = new Date();
                            }

                            this.filterdatestart = format(gte, formatDate);
                            this.filterdateend = format(lte, formatDate);
                            this.domain = domain;

                            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();

                            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), domain: domain, ipfw: ipfw }, function (respone) {
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
                    domain: 'all'
                },
                mounted() {
                    this.fillRangePicker('3hourago');
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
                            console.log("🚀 ~ file: Helper.js:860 ~ fillRangePicker ~ rangepicker:", rangepicker)
                            var formatDate = "yyyy-MM-dd";
                            var gte = '';
                            var lte = '';

                            if (rangepicker == "3hourago") {
                                gte = subHours(new Date(), 3);
                                lte = new Date();
                            } else if (rangepicker == "6hourago") {
                                gte = subHours(new Date(), 6);
                                lte = new Date();
                            }
                            else if (rangepicker == "12hourago") {
                                gte = subHours(new Date(), 12);
                                lte = new Date();
                            }
                            else if (rangepicker == "24hourago") {
                                gte = subHours(new Date(), 24);
                                lte = new Date();
                            }

                            this.filterdatestart = format(gte, formatDate);
                            this.filterdateend = format(lte, formatDate);
                            this.domain = domain;

                            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_logs&token=" + $("input[name=token]:first").val();
                            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), ipfw: ipfw, domain: domain, cmd: 'get_logs' }, function (respone) {
                                var gdata = JSON.parse(respone);
                                $('#fw_logs').show();
                                $('#fw_logs').val(gdata);
                                $('#vnx-loading-logs').hide();
                            });
                        }
                    }
                }

            });
        });
    }
};
export default Helper;

function date_now(date_string) {
    var date_components = date_string.split("/");
    var day = date_components[0];
    var month = date_components[1];
    var year = date_components[2];
    return new Date(year, month - 1, day);
}