$(document).ready(function() {
    $(".dropdown-form").on("click", function(event) {
        event.stopPropagation();
    });

    $(".battle-button").tooltip({placement: 'left'});
});

