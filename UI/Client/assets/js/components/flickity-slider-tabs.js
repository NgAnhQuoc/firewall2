const FlickitySliderTabs = {
  init() {
    new Flickity("#section-tab", {
      cellAlign: "left",
      contain: true,
      prevNextButtons: false,
      pageDots: false,
      mouseDrag: true,
    });
  },
};
export default FlickitySliderTabs;
