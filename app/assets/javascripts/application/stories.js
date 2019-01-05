jQuery(document).ready(function() {

  jQuery("[data-story]").on("click", function(){
    let story = jQuery(this);
    let id = story.attr("data-story");

    jQuery.post( "/stories/" + id + "/read")
      .done(function() {
        story.removeClass("unread");
      })
    return true;
  });
});
