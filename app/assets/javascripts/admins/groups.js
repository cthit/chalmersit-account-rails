// Dynamically add input fields
$('.add-link').click(function() {
    var selector = $(this).data('selector');
    var $elements = $(selector);
    var $element = $elements.last();
    var $parent = $element.parent();

    var $clone = $element.clone();
    $clone.find('input').val('');
    $clone.find('textarea').val('');
    $element.after($clone);

    disable_toggle(selector);
    return false;
}).each(function() {
    disable_toggle($(this).data('selector'))
});

// Toggle disable/enable on the given selector
function disable_toggle(selector) {
    var elems_left = $(selector).length;
    $(selector + ' .remove-link').toggleClass('disabled', elems_left == 1);
    return false;
}

// Dynamically remove stuff
$('body').on('click', '.remove-link', function() {
    var selector = $(this).data('selector');
    var elems_left = $(selector).length;

    if(elems_left > 1){
        $(this).closest(selector).remove();
    }

    disable_toggle(selector);
    return false;
});


