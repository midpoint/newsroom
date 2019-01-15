jQuery(document).on('turbolinks:load', function() {

  jQuery("[data-story]").on("click", function(){
    story = jQuery(this);
    id = story.attr("data-story");

    jQuery.post( "/stories/" + id + "/read")
      .done(function() {
        story.removeClass("unread");
      })
    return true;
  });
});
