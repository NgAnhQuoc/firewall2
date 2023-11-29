import GraphData from "./chartjs";

import {
    format,
    compareDesc,
    startOfDay,
    endOfDay,
    startOfYesterday,
    endOfYesterday,
    subDays,
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
        paginations = false,
        sort = false,
        tableSort = ""
    ) {
        var app = new Vue({
            delimiters: ["[[", "]]"],
            el: el,
            data: {
                tablename: el,
                localStorageKey: localStorageKey,
                search: "",
                filterdatestart: "",
                filterdateend: "",
                timerange: "custom",
                countByStatus: {},
                filterStatus: "",

                // Pagination define
                maxVisibleButtons: 50,
                totalPages: 1,
                totalItems: 0,
                perPage: 10,
                currentPage: 1,
                allItems: [],
                range: [],
            },

            computed: {
                newArrStatus() {
                    var el = this.tablename + " .vnx__table--body .vnx__table--row";
                    var allStatus = Array.from(
                        jQuery(el).map(function () {
                            var stt = jQuery(this)
                                .find(".status")
                                .text()
                                .trim();
                            return stt;
                        })
                    );

                    var allStatusClass = Array.from(
                        jQuery(el).map(function () {
                            var stt = jQuery(this)
                                .find(".status")
                                .attr("class");
                            return stt;
                        })
                    );

                    var classStatusRaw = allStatusClass.filter(function (item, pos) {
                        return allStatusClass.indexOf(item) === pos;
                    });

                    var classStatus = [];

                    for (let index = 0; index < classStatusRaw.length; index++) {
                        classStatus[index] =
                            "status-" + classStatusRaw[index].split("status-")[1];
                    }

                    var counts = [];
                    allStatus.forEach(function (item, pos) {
                        counts[item] = (counts[item] || 0) + 0.5;
                    });

                    this.countByStatus = { num: counts, classStatus: classStatus };

                    var uniqueArray = allStatus.filter(function (item, pos) {
                        return allStatus.indexOf(item) === pos;
                    });

                    if (uniqueArray.length == 1) {
                        return [];
                    }

                    return uniqueArray;
                },
            },

            watch: {
                search(val) {
                    this.handleSearch(val);
                    if (paginations) {
                        this.handlePagination();
                    }
                },
                filterdatestart() {
                    this.filterByDateRange();
                    if (paginations) {
                        this.handlePagination();
                    }
                },
                filterdateend() {
                    this.filterByDateRange();
                    if (paginations) {
                        this.handlePagination();
                    }
                },
                timerange(rangepicker) {
                    this.fillRangePicker(rangepicker);
                    if (paginations) {
                        this.handlePagination();
                    }
                },
                currentPage() {
                    this.range = [];
                    this.range = this.getPagination(this.currentPage, this.totalPages);
                },
            },

            mounted() {
                var status = localStorage.getItem(this.localStorageKey);
                if (status && this.newArrStatus.includes(status)) {
                    if (sort && tableSort) {
                        var sort_column =
                            localStorage.getItem(tableSort + "_sort_column") || 0;
                        this.handleSort(sort_column, false);
                    }

                    this.filterByStatus(null, status);
                } else {
                    if (sort && tableSort) {
                        var sort_column =
                            localStorage.getItem(tableSort + "_sort_column") || 0;
                        this.handleSort(sort_column, false);
                    } else if (paginations) {
                        this.handlePagination();
                    }
                }
            },

            methods: {
                filterByStatus(evt, status) {
                    localStorage.setItem(this.localStorageKey, status);

                    var el = this.tablename + " .vnx-tab--item";
                    var search = this.search;
                    var filterdatestart = this.filterdatestart;
                    var filterdateend = this.filterdateend;

                    jQuery(el).each(function (index, el) {
                        jQuery(el).removeClass("active");
                    });

                    jQuery(".vnx-tab--item[data-status='" + status + "']").addClass(
                        "active"
                    );

                    var body = this.tablename + " .vnx__table--body .vnx__table--row";
                    var result = 0;
                    var rs = jQuery(body).filter(function () {
                        var stt = jQuery(this)
                            .find(".status")
                            .text()
                            .trim();
                        var text = jQuery(this)
                            .text()
                            .toLowerCase()
                            .trim()
                            .replace(/(\r\n|\n|\r)+/gi, " ")
                            .trim();

                        var res = 1;

                        if (status) {
                            if (stt != status) {
                                res = 0;
                            }
                        }

                        if (search) {
                            if (text.indexOf(search.toLowerCase()) < 0) {
                                res = 0;
                            }
                        }

                        if (filterdatestart || filterdateend) {
                            var searchDayStart = filterdatestart ?
                                startOfDay(new Date(filterdatestart)) :
                                "";
                            var searchDayEnd = filterdateend ?
                                endOfDay(new Date(filterdateend)) :
                                "";

                            var time = jQuery(this)
                                .find(".lastreply")
                                .text()
                                .toLowerCase()
                                .trim()
                                .replace(/(\r\n|\n|\r)+/gi, " ")
                                .trim();
                            var timelastreply = new Date(time);

                            var resultCompare = 1;

                            if (searchDayStart && searchDayEnd) {
                                resultCompare =
                                    compareDesc(searchDayStart, timelastreply) < 0 ||
                                        compareDesc(timelastreply, searchDayEnd) < 0 ?
                                        -1 :
                                        1;
                            } else if (searchDayStart && !searchDayEnd) {
                                resultCompare = compareDesc(searchDayStart, timelastreply);
                            } else if (!searchDayStart && searchDayEnd) {
                                resultCompare = compareDesc(timelastreply, searchDayEnd);
                            }
                            if (resultCompare < 0) {
                                res = 0;
                            }
                        }

                        if (res) {
                            jQuery(this).removeClass("vf-hidden");
                            jQuery(this).addClass("vf-flex");
                        } else {
                            jQuery(this).removeClass("vf-flex");
                            jQuery(this).addClass("vf-hidden");
                        }

                        result += res;
                    });

                    if (result > 0) {
                        jQuery("#vnx-row--noresults").addClass("vf-hidden");
                    } else {
                        jQuery("#vnx-row--noresults").removeClass("vf-hidden");
                    }

                    if (paginations) {
                        this.handlePagination();
                    }
                },

                // filter search box
                handleSearch(searchVal) {
                    var el = this.tablename + " .vnx-tab--item.active";
                    var sttEl = jQuery(el);
                    var status = sttEl.length ?
                        sttEl
                            .attr("data-status")
                            .trim()
                            .toLowerCase() :
                        "";

                    var search = this.search;
                    var filterdatestart = this.filterdatestart;
                    var filterdateend = this.filterdateend;

                    var body = this.tablename + " .vnx__table--body .vnx__table--row";
                    var result = 0;
                    var rs = jQuery(body).filter(function () {
                        var stt = jQuery(this)
                            .find(".status")
                            .text()
                            .trim()
                            .toLowerCase();
                        var text = jQuery(this)
                            .text()
                            .toLowerCase()
                            .trim()
                            .replace(/(\r\n|\n|\r)+/gi, " ")
                            .trim();

                        var res = 1;

                        if (status) {
                            if (stt != status) {
                                res = 0;
                            }
                        }

                        if (search) {
                            if (text.indexOf(search.toLowerCase()) < 0) {
                                res = 0;
                            }
                        }

                        if (filterdatestart || filterdateend) {
                            var searchDayStart = filterdatestart ?
                                startOfDay(new Date(filterdatestart)) :
                                "";
                            var searchDayEnd = filterdateend ?
                                endOfDay(new Date(filterdateend)) :
                                "";

                            var time = jQuery(this)
                                .find(".lastreply")
                                .text()
                                .toLowerCase()
                                .trim()
                                .replace(/(\r\n|\n|\r)+/gi, " ")
                                .trim();
                            var timelastreply = new Date(time);

                            var resultCompare = 1;

                            if (searchDayStart && searchDayEnd) {
                                resultCompare =
                                    compareDesc(searchDayStart, timelastreply) < 0 ||
                                        compareDesc(timelastreply, searchDayEnd) < 0 ?
                                        -1 :
                                        1;
                            } else if (searchDayStart && !searchDayEnd) {
                                resultCompare = compareDesc(searchDayStart, timelastreply);
                            } else if (!searchDayStart && searchDayEnd) {
                                resultCompare = compareDesc(timelastreply, searchDayEnd);
                            }

                            if (resultCompare < 0) {
                                res = 0;
                            }
                        }

                        if (res) {
                            jQuery(this).removeClass("vf-hidden");
                            jQuery(this).addClass("flex");
                        } else {
                            jQuery(this).removeClass("vf-flex");
                            jQuery(this).addClass("vf-hidden");
                        }

                        result += res;
                    });

                    if (result > 0) {
                        jQuery("#vnx-row--noresults").addClass("vf-hidden");
                    } else {
                        jQuery("#vnx-row--noresults").removeClass("vf-hidden");
                    }
                },

                // filter range day
                filterByDateRange() {
                    var el = this.tablename + " .vnx-tab--item.active";
                    var sttEl = jQuery(el);
                    var status = sttEl.length ?
                        sttEl
                            .attr("data-status")
                            .trim()
                            .toLowerCase() :
                        "";

                    var search = this.search;
                    var filterdatestart = this.filterdatestart;
                    var filterdateend = this.filterdateend;

                    var body = this.tablename + " .vnx__table--body .vnx__table--row";
                    var result = 0;
                    var rs = jQuery(body).filter(function () {
                        var stt = jQuery(this)
                            .find(".status")
                            .text()
                            .trim()
                            .toLowerCase();
                        var text = jQuery(this)
                            .text()
                            .toLowerCase()
                            .trim()
                            .replace(/(\r\n|\n|\r)+/gi, " ")
                            .trim();

                        var res = 1;

                        if (status) {
                            if (stt != status) {
                                res = 0;
                            }
                        }

                        if (search) {
                            if (text.indexOf(search.toLowerCase()) < 0) {
                                res = 0;
                            }
                        }

                        if (filterdatestart || filterdateend) {
                            var searchDayStart = filterdatestart ?
                                startOfDay(new Date(filterdatestart)) :
                                "";
                            var searchDayEnd = filterdateend ?
                                endOfDay(new Date(filterdateend)) :
                                "";

                            var time = jQuery(this)
                                .find(".lastreply")
                                .text()
                                .toLowerCase()
                                .trim()
                                .replace(/(\r\n|\n|\r)+/gi, " ")
                                .trim();
                            var timelastreply = new Date(time);

                            var resultCompare = 1;

                            if (searchDayStart && searchDayEnd) {
                                resultCompare =
                                    compareDesc(searchDayStart, timelastreply) < 0 ||
                                        compareDesc(timelastreply, searchDayEnd) < 0 ?
                                        -1 :
                                        1;
                            } else if (searchDayStart && !searchDayEnd) {
                                resultCompare = compareDesc(searchDayStart, timelastreply);
                            } else if (!searchDayStart && searchDayEnd) {
                                resultCompare = compareDesc(timelastreply, searchDayEnd);
                            }

                            if (resultCompare < 0) {
                                res = 0;
                            }
                        }

                        if (res) {
                            jQuery(this).removeClass("vf-hidden");
                            jQuery(this).addClass("vf-flex");
                        } else {
                            jQuery(this).removeClass("vf-flex");
                            jQuery(this).addClass("vf-hidden");
                        }

                        result += res;
                    });

                    if (result > 0) {
                        jQuery("#vnx-row--noresults").addClass("vf-hidden");
                    } else {
                        jQuery("#vnx-row--noresults").removeClass("vf-hidden");
                    }

                    // this.timerange = "custom";
                    this.timerange = "custom";

                    var formatDate = "yyyy-MM-dd";
                    if (
                        isToday(new Date(this.filterdatestart)) &&
                        isToday(new Date(this.filterdateend))
                    ) {
                        this.timerange = "today";
                    } else if (
                        isYesterday(new Date(this.filterdatestart)) &&
                        isYesterday(new Date(this.filterdateend))
                    ) {
                        this.timerange = "yesterday";
                    } else if (
                        this.filterdatestart ==
                        format(startOfDay(subDays(new Date(), 7)), formatDate) &&
                        this.filterdateend == format(endOfDay(new Date()), formatDate)
                    ) {
                        this.timerange = "7daysago";
                    } else if (
                        this.filterdatestart ==
                        format(startOfDay(subDays(new Date(), 7)), formatDate) &&
                        this.filterdateend == format(endOfDay(new Date()), formatDate)
                    ) {
                        this.timerange = "30daysago";
                    } else if (
                        this.filterdatestart ==
                        format(startOfDay(subMonths(new Date(), 3)), formatDate) &&
                        this.filterdateend == format(endOfDay(new Date()), formatDate)
                    ) {
                        this.timerange = "3monthsago";
                    } else {
                        this.timerange = "custom";
                    }
                },

                // fill input datestart, dateend
                fillRangePicker(rangepicker) {
                    if (rangepicker) {
                        var formatDate = "yyyy-MM-dd";
                        if (rangepicker == "today") {
                            this.filterdatestart = format(startOfDay(new Date()), formatDate);
                            this.filterdateend = format(endOfDay(new Date()), formatDate);
                        } else if (rangepicker == "yesterday") {
                            this.filterdatestart = format(startOfYesterday(), formatDate);
                            this.filterdateend = format(endOfYesterday(), formatDate);
                        } else if (rangepicker == "7daysago") {
                            this.filterdatestart = format(
                                startOfDay(subDays(new Date(), 7)),
                                formatDate
                            );
                            this.filterdateend = format(endOfDay(new Date()), formatDate);
                        } else if (rangepicker == "30daysago") {
                            this.filterdatestart = format(
                                startOfDay(subDays(new Date(), 30)),
                                formatDate
                            );
                            this.filterdateend = format(endOfDay(new Date()), formatDate);
                        } else if (rangepicker == "3monthsago") {
                            this.filterdatestart = format(
                                startOfDay(subMonths(new Date(), 3)),
                                formatDate
                            );
                            this.filterdateend = format(endOfDay(new Date()), formatDate);
                        }
                    }
                },

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

                    var el =
                        this.tablename +
                        " .vnx__table--body .vnx__table--row:not('.vf-hidden')";
                    jQuery(el).filter((pos, items) => {
                        this.allItems.push({ pos: pos, id_item: items.getAttribute("id") });
                    });


                    var Items = Array.from(
                        jQuery(el).map(function () {
                            var row = jQuery(this)
                                .find(".vnx__table--col")
                                .text()
                                .trim();
                            return row;
                        })
                    );

                    this.totalPages = Math.round(Math.ceil(((Items.length)) / this.perPage)); // :2 IF HAVE MOBILE MODE

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

                    var rowShow = [];

                    for (
                        var i = (this.currentPage - 1) * this.perPage; i < this.currentPage * this.perPage; i++
                    ) {
                        rowShow.push(i);
                    }

                    jQuery(this.allItems).filter(function (pos, item) {
                        if (rowShow.includes(item.pos)) {
                            jQuery("#" + item.id_item + "").removeClass("vf-hidden");
                            jQuery("#" + item.id_item + "").addClass("vf-flex");
                        } else {
                            jQuery("#" + item.id_item + "").removeClass("vf-flex");
                            jQuery("#" + item.id_item + "").addClass("vf-hidden");
                        }
                    });
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

                handleSort(index, onclick = true) {
                    var direction = localStorage.getItem(tableSort + "_sort_direction") ?
                        localStorage.getItem(tableSort + "_sort_direction") :
                        "desc";

                    if (onclick) {
                        var direction = direction === "asc" ? "desc" : "asc";
                        localStorage.setItem(tableSort + "_sort_column", index);
                        localStorage.setItem(tableSort + "_sort_direction", direction);
                    }

                    this.sortColumn(index, direction);

                    if (localStorage.getItem(this.localStorageKey)) {
                        this.filterByStatus(
                            null,
                            localStorage.getItem(this.localStorageKey)
                        );
                    } else if (this.search) {
                        this.handleSearch(this.search);
                        if (paginations) {
                            this.handlePagination();
                        }
                    } else if (paginations) {
                        this.handlePagination();
                    }
                },

                sortColumn(index, direction) {
                    var table = document.getElementById(tableSort);
                    var tableBody = table.querySelector(".vnx__table--body");
                    var rows = tableBody.querySelectorAll(".vnx__table--row");

                    var multiplier = direction === "asc" ? 1 : -1;

                    var newRows = Array.from(rows);

                    newRows.sort(function (rowA, rowB) {
                        var cellA = rowA
                            .querySelectorAll(".vnx__table--col")[index].getAttribute("data-value");
                        var cellB = rowB
                            .querySelectorAll(".vnx__table--col")[index].getAttribute("data-value");

                        var type = document
                            .getElementById(tableSort)
                            .querySelectorAll(".vf-sort")[index].getAttribute("data-type");
                        switch (type) {
                            case "number":
                                cellA = parseFloat(cellA);
                                cellB = parseFloat(cellB);
                                break;
                            default:
                                break;
                        }

                        var a = cellA;
                        var b = cellB;

                        switch (true) {
                            case a > b:
                                return 1 * multiplier;
                            case a < b:
                                return -1 * multiplier;
                            case a === b:
                                return 0;
                        }
                    });

                    [].forEach.call(rows, function (row) {
                        tableBody.removeChild(row);
                    });

                    newRows.forEach(function (newRow) {
                        newRow.classList.remove("vf-hidden");
                        tableBody.appendChild(newRow);
                    });
                },

                getActiveSortColunm(index, vector) {
                    var direction = localStorage.getItem(tableSort + "_sort_direction") ?
                        localStorage.getItem(tableSort + "_sort_direction") :
                        "desc";
                    var sort_column =
                        localStorage.getItem(tableSort + "_sort_column") || 0;

                    if (direction) {
                        if (sort_column == index && vector == direction) {
                            return "";
                        } else {
                            return "vf-hidden";
                        }
                    }
                },

                checkInvoiceSendMessage(invoiceid) {
                    if (document.cookie.indexOf("vnx_notif_invoice" + invoiceid) !== -1) {
                        return "vf-hidden";
                    }
                    return "";
                },
                //**********************
            },
            //******
        });
    },
    //******


    initGraphData(sid, regdate) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var gte = startOfDay(new Date());
            var lte = endOfDay(new Date());
            var rdate = new Date(regdate).toISOString();
            var now = new Date().toISOString();

            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();
            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString() }, function (respone) {
                var gdata = JSON.parse(respone);
                GraphData.update_chart_data(gdata);
            });

            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();
            $.post(reqstr, { gte: rdate, lte: now, cmd: 'get_data_transfer' }, function (respone) {
                var gdata = JSON.parse(respone);
                $('#fw-data-transfer').html(gdata);
            });
        });
    },

    initGraphDetail(sid, data) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var chart = new Vue({
                delimiters: ["[[", "]]"],
                el: '#fw-graph-detail',
                data: {
                    filterdatestart: '',
                    filterdateend: '',
                    timerange: 'custom',
                    domain: 'all'
                },
                mounted() {
                    this.fillRangePicker('7daysago');
                },
                watch: {
                    filterdatestart() {
                        this.filterByDateRange();
                    },
                    filterdateend() {
                        this.filterByDateRange();

                    },
                    timerange(rangepicker) {
                        this.fillRangePicker(rangepicker, this.domain);
                    },
                    domain(domain) {
                        this.fillRangePicker(this.timerange, domain);
                    }
                },
                methods: {
                    // Filter range day
                    filterByDateRange() {
                        this.timerange = "custom";
                        var formatDate = "yyyy-MM-dd";

                        if (
                            isToday(new Date(this.filterdatestart)) &&
                            isToday(new Date(this.filterdateend))
                        ) {
                            this.timerange = "today";
                        } else if (
                            isYesterday(new Date(this.filterdatestart)) &&
                            isYesterday(new Date(this.filterdateend))
                        ) {
                            this.timerange = "yesterday";
                        } else if (
                            this.filterdatestart ==
                            format(startOfDay(subDays(new Date(), 7)), formatDate) &&
                            this.filterdateend == format(endOfDay(new Date()), formatDate)
                        ) {
                            this.timerange = "7daysago";
                        } else if (
                            this.filterdatestart ==
                            format(startOfDay(subDays(new Date(), 30)), formatDate) &&
                            this.filterdateend == format(endOfDay(new Date()), formatDate)
                        ) {
                            this.timerange = "30daysago";
                        } else if (
                            this.filterdatestart ==
                            format(startOfDay(subMonths(new Date(), 3)), formatDate) &&
                            this.filterdateend == format(endOfDay(new Date()), formatDate)
                        ) {
                            this.timerange = "3monthsago";
                        } else {
                            this.timerange = "custom";
                        }
                    },

                    fillRangePicker(rangepicker, domain = 'all') {
                        if (rangepicker) {
                            var formatDate = "yyyy-MM-dd";
                            var gte = '';
                            var lte = '';

                            if (rangepicker == "today") {
                                gte = startOfDay(new Date());
                                lte = endOfDay(new Date());
                            } else if (rangepicker == "yesterday") {
                                gte = startOfYesterday();
                                lte = endOfYesterday();
                            } else if (rangepicker == "7daysago") {
                                gte = startOfDay(subDays(new Date(), 7));
                                lte = endOfDay(new Date());
                            } else if (rangepicker == "30daysago") {
                                gte = startOfDay(subDays(new Date(), 30));
                                lte = endOfDay(new Date());
                            } else if (rangepicker == "3monthsago") {
                                gte = startOfDay(subMonths(new Date(), 3));
                                lte = endOfDay(new Date());
                            }

                            this.filterdatestart = format(gte, formatDate);
                            this.filterdateend = format(lte, formatDate);
                            this.domain = domain;

                            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_graph&token=" + $("input[name=token]:first").val();

                            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString() }, function (respone) {
                                var gdata = JSON.parse(respone);
                                GraphData.update_chart_data(gdata);
                            });
                        }
                    },
                }
            });
        });
    },

    initLogsDetail(sid) {
        window.addEventListener("DOMContentLoaded", (event) => {
            var logs = new Vue({
                delimiters: ["[[", "]]"],
                el: '#vnx-fwlogs-table',
                data: {
                    filterdatestart: '',
                    filterdateend: '',
                    timerange: 'custom',
                    domain: 'all'
                },
                mounted() {
                    this.fillRangePicker('7daysago', 'all');
                },

                watch: {
                    filterdatestart() {
                        this.filterByDateRange();
                    },
                    filterdateend() {
                        this.filterByDateRange();

                    },
                    timerange(rangepicker) {
                        this.fillRangePicker(rangepicker, this.domain);
                    },
                    domain(domain) {
                        this.fillRangePicker(this.timerange, domain);
                    }
                },
                methods: {
                    // Filter range day
                    filterByDateRange() {
                        this.timerange = "custom";
                        var formatDate = "yyyy-MM-dd";

                        if (
                            isToday(new Date(this.filterdatestart)) &&
                            isToday(new Date(this.filterdateend))
                        ) {
                            this.timerange = "today";
                        } else if (
                            isYesterday(new Date(this.filterdatestart)) &&
                            isYesterday(new Date(this.filterdateend))
                        ) {
                            this.timerange = "yesterday";
                        } else if (
                            this.filterdatestart ==
                            format(startOfDay(subDays(new Date(), 7)), formatDate) &&
                            this.filterdateend == format(endOfDay(new Date()), formatDate)
                        ) {
                            this.timerange = "7daysago";
                        } else if (
                            this.filterdatestart ==
                            format(startOfDay(subDays(new Date(), 30)), formatDate) &&
                            this.filterdateend == format(endOfDay(new Date()), formatDate)
                        ) {
                            this.timerange = "30daysago";
                        } else if (
                            this.filterdatestart ==
                            format(startOfDay(subMonths(new Date(), 3)), formatDate) &&
                            this.filterdateend == format(endOfDay(new Date()), formatDate)
                        ) {
                            this.timerange = "3monthsago";
                        } else {
                            this.timerange = "custom";
                        }
                    },

                    fillRangePicker(rangepicker, domain = 'all') {
                        if (rangepicker) {
                            var formatDate = "yyyy-MM-dd";
                            var gte = '';
                            var lte = '';

                            if (rangepicker == "today") {
                                gte = startOfDay(new Date());
                                lte = endOfDay(new Date());
                            } else if (rangepicker == "yesterday") {
                                gte = startOfYesterday();
                                lte = endOfYesterday();
                            } else if (rangepicker == "7daysago") {
                                gte = startOfDay(subDays(new Date(), 7));
                                lte = endOfDay(new Date());
                            } else if (rangepicker == "30daysago") {
                                gte = startOfDay(subDays(new Date(), 30));
                                lte = endOfDay(new Date());
                            } else if (rangepicker == "3monthsago") {
                                gte = startOfDay(subMonths(new Date(), 3));
                                lte = endOfDay(new Date());
                            }

                            this.filterdatestart = format(gte, formatDate);
                            this.filterdateend = format(lte, formatDate);
                            this.domain = domain;

                            var reqstr = "clientarea.php?action=productdetails&id=" + sid + "&modop=custom&a=view_logs&token=" + $("input[name=token]:first").val();

                            $.post(reqstr, { gte: gte.toISOString(), lte: lte.toISOString(), domain: domain }, function (respone) {
                                var gdata = JSON.parse(respone);
                                $('#fw_logs').val(gdata);
                            });
                        }
                    }
                }

            });
        });
    }
};

export default Helper;