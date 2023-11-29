const Commons = {
  addSpinnerBtn() {
    jQuery(".vnx-spinner-btn").click(function () {
      $(this).addClass('vnx-loading-btn');
    });
  },
};

export default Commons;