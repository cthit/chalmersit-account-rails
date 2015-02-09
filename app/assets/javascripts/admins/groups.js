// Dynamically add input fields
$('.addLink').click(function() {
    var selector = $(this).data('selector');
    var $elements = $(selector);
    var $element = $elements.last();
    var $parent = $element.parent();

    var $clone = $element.clone()
    $clone.find('input').val('')
    $clone.find('textarea').val('')
    $element.after($clone);
});
