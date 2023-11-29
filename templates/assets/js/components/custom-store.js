import Ion from "./Ion";

const CustomStore = {
    init(token, groups) {
        var app = new Vue({
            delimiters: ["[[", "]]"],
            el: "#vietnix__store",
            data: {
                token: token,
                groups: groups,

                step: 1,
                loading: false,

                tab: {
                    items: [],
                    start: 'hosting',
                    selected: '',
                    name: ''
                },

                group: {
                    items: [],
                    startGid: 0,
                    selected: 0,
                    name: ''
                },

                products: [],
                emptyProduct: 0,
                billingcycle: "",

                selectedProductId: 0,
                selectedProductInfo: {},
                mhtml: "",

                i: 0,

                sectionDomain: {
                    show: false,
                    domainoption: "register",

                    input: "",
                    checking: false,
                    fetchingSuggestions: false,

                    checkResult: undefined,

                    sld: "",
                    tld: ".com",
                },

                customStylePadding: "",

                registrationDomain: {
                    isTranferDomain: false,
                    checking: 0,

                    input: "",
                    code: "",

                    cart: [],

                    domainInfo: undefined,
                    suggestions: [],
                },
            },

            mounted() {
                var gid = new URL(location.href).searchParams.get("gid");
                var pid = new URL(location.href).searchParams.get("pid");
                var tab = new URL(location.href).searchParams.get("tab");

                if (!tab && this.tab.start && window.location.pathname == '/store.php') {
                    tab = this.tab.start;
                    window.history.pushState("", "", whmcsBaseUrl + "/store.php?tab=" + tab);
                }

                // if (!gid && this.group.startGid) {
                //   window.history.pushState("", "", whmcsBaseUrl + "/store.php?gid=" + this.group.startGid);
                //   gid = this.group.startGid;
                // }

                if (gid && pid) {
                    this.group.selected = gid;

                    let count = 0;
                    let self = this;
                    var timer = setInterval(function() {
                        count++;

                        if (count >= 50 || self.products.length) {
                            clearInterval(timer);

                            var product = self.products.find(function(item) {
                                return item.id == pid;
                            });

                            if (!product) {
                                return;
                            }

                            var billingcycle = new URL(location.href).searchParams.get("c");

                            if (["monthly", "quarterly", "semiannually", "annually", "biennially", "triennially"].includes(billingcycle)) {
                                jQuery(self.$refs["billingcycle" + product.id][0]).val(billingcycle);
                            }

                            self.handleSelectProduct(product);
                        }
                    }, 100);

                    this.getSelectedGroupActiveClass(gid);
                } else if (gid) {
                    this.group.selected = gid;
                    this.getSelectedGroupActiveClass(gid);
                } else if (tab) {
                    this.tab.selected = tab;
                }
            },

            watch: {
                "group.selected" (gid, oldVal) {
                    this.step = 2;
                    this.selectedProductId = 0;
                    this.mhtml = "";

                    var pid = new URL(location.href).searchParams.get("pid");

                    if (gid != 0) {
                        if (oldVal || !pid) {
                            window.history.pushState("", "", whmcsBaseUrl + "/store.php?gid=" + gid);
                        }
                        this.fetchData(gid);
                    }
                },
            },

            methods: {
                scrollIntoBottom() {
                    let index = 0;
                    const timer = setInterval(() => {
                        index++;
                        window.scrollTo(0, document.body.scrollHeight);

                        if (jQuery(window).scrollTop() + jQuery(window).height() === jQuery(document).height()) {
                            clearInterval(timer);
                        }

                        if (index >= 4) {
                            clearInterval(timer);
                        }
                    }, 200);
                },

                fetchData(groupId) {
                    this.scrollIntoBottom();

                    this.products = [];

                    jQuery.post(whmcsBaseUrl + "/store.php", { gid: this.group.selected, action: "products" })
                        .done((response) => {
                            // console.log("🚀 ~ file: custom-store.js ~ line 163 ~ .done ~ response", response)
                            this.products = JSON.parse(response).products;

                            if (this.products.length) {
                                for (let index = 0; index < this.products.length; index++) {
                                    const product = this.products[index];

                                    let arrDescription = product.description.split("\r\n");

                                    this.products[index].arrDescription = [];

                                    for (let y = 0; y < arrDescription.length; y++) {

                                        const productDesc = arrDescription[y];

                                        let cell = productDesc.split('___');

                                        if (cell[2]) {
                                            product.description = "";
                                        }

                                        for (let z = 0; z < cell.length; z++) {
                                            cell[z].trim();
                                            let cellArr = cell[z].split('===');
                                            cell[z] = {
                                                value: cellArr[0] ? cellArr[0].trim().replace(/"|'/g, "") : '',
                                                style: cellArr[1] ? cellArr[1].trim() : ''
                                            };
                                        }

                                        this.products[index].arrDescription.push({
                                            icon: cell[0] ? cell[0] : '',
                                            label: cell[1] ? cell[1] : '',
                                            content: cell[2] ? cell[2] : '',
                                            showInList: cell[3] ? cell[3] : '',
                                        })

                                    }
                                }
                            } else {
                                this.emptyProduct = 1;
                            }
                        });
                },

                getSelectedTabActiveClass(tab) {
                    if (this.group.selected == 0) {
                        if (this.tab.selected == tab) {
                            this.tab.selected = tab;
                            return 'active';
                        }
                    } else if (tab && this.group.name.toLowerCase().includes(tab)) {
                        return 'active';
                    }
                },

                getSelectedGroupActiveClass(groupId, groupName = null) {
                    if (groupId) {
                        if (groupName && this.group.selected == groupId) {
                            this.group.name = groupName;
                        }
                        return this.group.selected == groupId ? "active" : "";
                    } else if (groupName && this.group.name.toLowerCase().includes(groupName)) {
                        return 'active';
                    }
                },

                getProductClass(productId) {
                    return this.selectedProductId == productId ? "active" : "";
                },

                formatMoney(xamount, decimalCount = 0, decimal = ".", thousands = ",", recurring = ' / ') {
                    var amount = parseInt(xamount.replace(".00", ""));
                    var formatter = new Intl.NumberFormat("vi-VN", {
                        style: "currency",
                        currency: "VND",
                    });

                    if (amount != 0) {
                        return formatter.format(amount) + recurring;
                    }
                    return "";
                },

                handleSelectTab(name) {
                    if (name) {
                        this.tab.selected = name;
                        window.history.pushState("", "", whmcsBaseUrl + "/store.php?tab=" + this.tab.selected);
                        if (!(this.tab.selected.toLowerCase().includes("hosting") && this.tab.selected.toLowerCase().includes("vps"))) {
                            this.group.selected = 0;
                        }
                    }
                },

                handleSelectGroup(id, name = null) {
                    this.emptyProduct = 0;
                    if (name.toLowerCase().includes("hosting")) {
                        this.tab.selected = 'hosting';
                    } else if (name.toLowerCase().includes("vps")) {
                        this.tab.selected = 'vps';
                    } else {
                        this.tab.selected = '';
                    }

                    this.group.selected = id;
                    if (name) {
                        this.group.name = name;
                    }
                },

                handleSelectProduct(product) {
                    this.i += 1;
                    this.step = 2;
                    this.selectedProductInfo = product;
                    this.selectedProductId = product.id;

                    this.sectionDomain.show = false;

                    if (product.type == "hostingaccount") {
                        this.sectionDomain.show = true;
                        this.sectionDomain.input = "";
                        this.step = 3;
                        try {
                            setTimeout(() => {
                                jQuery("#input-hosting-domain").focus();
                            }, 100);
                        } catch (error) {}
                    }

                    var billingcycle = '';
                    this.scrollIntoBottom();
                    if (product.paytype == 'recurring') {
                        var billingcycle = this.$refs["billingcycle" + product.id][0].value;
                    }

                    this.mhtml = "";

                    if (product.ptype == 'bundles') {
                        window.location.href = whmcsBaseUrl + "/cart.php?a=add&bid=" + this.selectedProductId + (billingcycle ? "&billingcycle=" + billingcycle : '');
                    } else {
                        window.location.href = whmcsBaseUrl + "/cart.php?a=add&pid=" + this.selectedProductId + (billingcycle ? "&billingcycle=" + billingcycle : '');
                    }

                    jQuery.post(whmcsBaseUrl + "/cart.php?a=add&pid=" + product.id, { billingcycle: billingcycle }).done((resp) => {
                        if (product.type == "hostingaccount") {
                            return;
                        }

                        var srctext = resp;
                        if (srctext.includes("frmConfigureProduct")) {
                            var text = srctext.split("<form")[1];
                            text = text.split("form>")[0];
                            this.mhtml = "<form" + text + "form>";

                            if (!jQuery("#orderSummaryLoader").is(":visible")) {
                                jQuery("#orderSummaryLoader").fadeIn("fast");
                            }

                            var thisRequestId = Math.floor(Math.random() * 1000000 + 1);
                            window.lastSliderUpdateRequestId = thisRequestId;

                            var pid = this.selectedProductId;

                            var post = WHMCS.http.jqClient.post("cart.php", "ajax=1&a=confproduct&calctotal=true&" + jQuery("#frmConfigureProduct").serialize());
                            post.done((data) => {
                                if (window.lastSliderUpdateRequestId == thisRequestId) {
                                    jQuery("#producttotal").html(data);

                                    if (pid == 154) {
                                        Ion.init();
                                        setTimeout(() => {
                                            this.initSlider154();
                                        }, 1000);
                                    }
                                }
                            });

                            post.always(function() {
                                jQuery("#orderSummaryLoader")
                                    .delay(500)
                                    .fadeOut("slow");
                            });
                            //
                            this.validateHostName();
                            //
                        }
                    });
                },

                handleCheckDomain() {
                    var product = this.selectedProductInfo;
                    var billingcycle = this.$refs["billingcycle" + product.id][0].value;

                    this.step = 3;
                    if (!this.sectionDomain.input) {
                        this.sectionDomain.checkResult = {
                            error: "Domain nhập vào không hợp lệ.",
                        };
                        return;
                    }

                    var arr = this.sectionDomain.input.split(".");

                    if (arr.length < 2) {
                        this.sectionDomain.checkResult = {
                            error: "Domain nhập vào không hợp lệ.",
                        };
                        return;
                    }

                    if (this.sectionDomain.input.includes("_")) {
                        this.sectionDomain.checkResult = {
                            error: "Domain nhập vào không hợp lệ. Domain không được chứa ký tự _ ",
                        };
                        return;
                    }

                    var tld = "." + arr[arr.length - 1];

                    if (arr.length == 3) {
                        tld = "." + arr[arr.length - 2] + "." + arr[arr.length - 1];
                    }

                    var sld = this.sectionDomain.input.replace(tld, "");

                    this.sectionDomain.checking = true;
                    jQuery
                        .post(whmcsBaseUrl + "/index.php?rp=/domain/check", {
                            token: this.token,
                            type: "owndomain",
                            source: "cartAddDomain",
                            pid: this.selectedProductId,
                            billingcycle: billingcycle,
                            domain: this.sectionDomain.input,
                            sld: sld,
                            tld: tld,
                        })
                        .done((resp) => {
                            if (resp.result && resp.result[0] && resp.result[0].status == true) {
                                this.sectionDomain.checkResult = resp.result[0];
                                this.i = this.sectionDomain.checkResult.num;
                                this.handleCheckDomainNext();
                            } else {
                                this.sectionDomain.checkResult = resp.result;
                            }
                            this.sectionDomain.checking = false;
                        });
                },

                handleCheckDomainNext() {
                    this.step = 4;
                    var product = this.selectedProductInfo;
                    var billingcycle = this.$refs["billingcycle" + product.id][0].value;

                    this.mhtml = "";

                    var arr = this.sectionDomain.input.split(".");

                    var tld = "." + arr[arr.length - 1];

                    if (arr.length == 3) {
                        tld = "." + arr[arr.length - 2] + "." + arr[arr.length - 1];
                    }

                    var sld = this.sectionDomain.input.replace(tld, "");

                    jQuery
                        .post(whmcsBaseUrl + "/cart.php?a=add&pid=" + this.selectedProductId, {
                            token: this.token,
                            domainoption: "owndomain",
                            sldtld: this.sectionDomain.input,
                            sld: sld,
                            tld: tld,
                            billingcycle: billingcycle,
                        })
                        .done((resp) => {
                            if (resp.includes("frmConfigureProduct")) {
                                var text = resp.split("<form")[1];
                                text = text.split("form>")[0];
                                this.mhtml = "<form" + text + "form>";

                                const post = WHMCS.http.jqClient.post(
                                    "cart.php",
                                    "ajax=1&a=confproduct&calctotal=true&billingcycle=" + billingcycle + "&pid=" + product.id + "&i=" + this.i
                                );

                                post.done((data) => {
                                    jQuery("#producttotal").html(data);
                                });
                                post.always(function() {
                                    jQuery("#orderSummaryLoader")
                                        .delay(1000)
                                        .fadeOut("slow");
                                });

                                this.validateHostName();
                            }
                        });
                },

                replaceNewline(str) {
                    return str.replace(/\n/g, "<br />");
                },

                handleCheckRegistrationDomain() {
                    this.registrationDomain.checking = 2;
                    this.registrationDomain.domainInfo = undefined;
                    this.registrationDomain.suggestions = undefined;

                    if (this.registrationDomain.isTranferDomain) {
                        this.handleCheckTranferDomain();
                        return;
                    }

                    jQuery.post(whmcsBaseUrl + "/index.php?rp=/domain/check", {
                        token: this.token,
                        a: "checkDomain",
                        type: "domain",
                        domain: this.registrationDomain.input,
                    }).done((resp) => {
                        if (resp.result && resp.result[0]) {
                            this.registrationDomain.domainInfo = resp.result[0];
                        } else if (resp.result) {
                            this.registrationDomain.domainInfo = resp.result;
                        }

                        this.registrationDomain.checking--;
                    });

                    jQuery.post(whmcsBaseUrl + "/index.php?rp=/domain/check", {
                        token: this.token,
                        a: "checkDomain",
                        type: "suggestions",
                        domain: this.registrationDomain.input,
                    }).done((resp) => {
                        if (resp.result) {
                            this.registrationDomain.suggestions = resp.result;
                        }

                        this.registrationDomain.checking--;
                    });
                },

                handleCheckTranferDomain() {
                    if (!this.registrationDomain.code) {
                        this.registrationDomain.checking -= 2;
                        return;
                    }

                    jQuery
                        .post(whmcsBaseUrl + "/cart.php", {
                            token: this.token,
                            a: "addDomainTransfer",
                            domain: this.registrationDomain.input,
                            epp: this.registrationDomain.code,
                        })
                        .done((resp) => {
                            if (resp.result) {
                                if (resp.result == "added") {
                                    window.location.href = whmcsBaseUrl + "/cart.php?a=confdomains";
                                    return;
                                }

                                this.registrationDomain.domainInfo = resp.result;
                            }

                            this.registrationDomain.checking -= 2;
                        });
                },

                handleAddDomainToCart(domain, whois = 0, sideorder = 0) {
                    this.registrationDomain.cart.push(domain);

                    jQuery
                        .post(whmcsBaseUrl + "/cart.php", {
                            token: this.token,
                            a: "addToCart",
                            whois: whois,
                            sideorder: sideorder,
                            domain: domain,
                        })
                        .done((resp) => {});
                },

                initSlider154() {
                    var sliderTimeoutId = null;
                    var sliderRangeDifference = 32 - 1;
                    var sliderStepThreshold = 25;
                    var setLargerMarkers = sliderRangeDifference > sliderStepThreshold;

                    jQuery("#inputConfigOption209").ionRangeSlider({
                        min: 1,
                        max: 32,
                        grid: true,
                        grid_snap: setLargerMarkers ? false : true,
                        onChange: function() {
                            if (sliderTimeoutId) {
                                clearTimeout(sliderTimeoutId);
                            }

                            sliderTimeoutId = setTimeout(function() {
                                sliderTimeoutId = null;
                                recalctotals();
                            }, 250);
                        },
                    });
                    //
                    var sliderTimeoutId = null;
                    var sliderRangeDifference = 64 - 1;
                    var sliderStepThreshold = 25;
                    var setLargerMarkers = sliderRangeDifference > sliderStepThreshold;

                    jQuery("#inputConfigOption208").ionRangeSlider({
                        min: 1,
                        max: 64,
                        grid: true,
                        grid_snap: setLargerMarkers ? false : true,
                        onChange: function() {
                            if (sliderTimeoutId) {
                                clearTimeout(sliderTimeoutId);
                            }

                            sliderTimeoutId = setTimeout(function() {
                                sliderTimeoutId = null;
                                recalctotals();
                            }, 250);
                        },
                    });
                    //
                    var sliderTimeoutId = null;
                    var sliderRangeDifference = 1000 - 20;
                    var sliderStepThreshold = 25;
                    var setLargerMarkers = sliderRangeDifference > sliderStepThreshold;

                    jQuery("#inputConfigOption207").ionRangeSlider({
                        min: 20,
                        max: 1000,
                        grid: true,
                        grid_snap: setLargerMarkers ? false : true,
                        onChange: function() {
                            if (sliderTimeoutId) {
                                clearTimeout(sliderTimeoutId);
                            }

                            sliderTimeoutId = setTimeout(function() {
                                sliderTimeoutId = null;
                                recalctotals();
                            }, 250);
                        },
                    });
                    //
                },

                validateHostName() {
                    setTimeout(() => {
                        jQuery("button#btnCompleteProductConfig").click((e) => {
                            const hostname = jQuery("#inputHostname").val();
                            var pattern = new RegExp("^([a-zA-Z0-9]+)$");

                            if (
                                this.group.selected !== 999 &&
                                this.selectedProductInfo.type !== "hostingaccount" &&
                                this.selectedProductInfo.type !== "other" &&
                                !pattern.test(hostname)
                            ) {
                                if (!jQuery("#hostname_error").length) {
                                    jQuery(
                                        '<p id="hostname_error" class="form-text text-danger" style="font-size: 14px; margin-top: 4px;">Vui lòng điền hostname và không được chứa các ký tự đặc biệt.</p>'
                                    ).insertAfter("#inputHostname");
                                }

                                const element = document.getElementById("inputHostname");
                                const y = element.getBoundingClientRect().top + window.pageYOffset - 160;
                                window.scrollTo({ top: y, behavior: "smooth" });
                            } else {
                                var total = jQuery(".total-due-today .amt")[0].innerText;
                                total = total
                                    .trim()
                                    .replace(/(,|\.|VND)+/gi, "")
                                    .trim();

                                var selectedGroup = "";
                                if (this.group.selected === 999) {
                                    selectedGroup = "Domain";
                                } else {
                                    selectedGroup = this.groups.find((item) => item.id === this.selectedProductInfo.gid);
                                    if (selectedGroup) {
                                        selectedGroup = selectedGroup.name;
                                    }
                                }

                                const formData = new FormData();
                                formData.append("action", "conversions-api-2");
                                formData.append("event_name", "InitiateCheckout");
                                formData.append("event_source_url", window.location.href);
                                formData.append("value", total);
                                formData.append("content_category", selectedGroup);
                                formData.append("content_name", this.selectedProductInfo.name);

                                fetch(whmcsBaseUrl + "/store.php", {
                                        method: "POST",
                                        body: formData,
                                    })
                                    .then((response) => response.json())
                                    .then((data) => {
                                        // jQuery("form#frmConfigureProduct").submit();
                                        // console.log("redirect");
                                    })
                                    .catch((error) => {
                                        // jQuery("form#frmConfigureProduct").submit();
                                        // console.log("redirect");
                                    });

                                jQuery("form#frmConfigureProduct").submit();
                            }

                            e.preventDefault();
                            e.stopPropagation();
                            e.stopImmediatePropagation();
                            return false;
                        });
                    }, 2000);
                },

            },
        });
    },
};

export default CustomStore;