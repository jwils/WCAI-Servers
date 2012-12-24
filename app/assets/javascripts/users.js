$(function() {
    $('select#invitations_role').on('change', function() {
        if( this.value == 6) {
            $('div#research-projects-list').show()
        } else {
            $('div#research-projects-list').hide();
        }
    });
});
