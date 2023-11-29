const FlickitySlider = {
	init() {
		var flkty = new Flickity('.main-carousel', {
			cellAlign: 'left',
			contain: true
		});
		jQuery('.flickity-prev-next-button.next').html("<i class=\"fas fa-long-arrow-alt-right\"></i>");
		jQuery('.flickity-prev-next-button.previous').html("<i class=\"fas fa-long-arrow-alt-left\"></i>");
	}
}
export default FlickitySlider;