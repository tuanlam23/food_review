$(function () {
    $('body').on('click', '.follow', function (event) {
       event.preventDefault();
       var object = $(this);
       var restaurant_id = $(this).attr('data-res');
        $.ajax({
            url: $(this).attr('data-url'),
            type: "POST",
            dataType: 'json',
            data: {restaurant_id: restaurant_id},
            success: function (res) {
                if(res.status == true && res.data=='success')
                {
                    object.addClass('res-active');
                }
                if(res.status == true && res.data=='delete')
                {
                    object.removeClass('res-active');
                }
            },
            error: function (res) {
                console.log(res);
            }
        });

    });
    $('body').on('click', '.load-page', function (event) {
        var page = $(this).attr('data-page');
        var url = $(this).attr('data-url');
        $.ajax({
            url: url + "?page=" + page,
            type: "GET",
            dataType: 'json',
            success: function (res) {
                if(res.status == true && res.data=='success')
                {
                    object.addClass('res-active');
                }
                if(res.status == true && res.data=='delete')
                {
                    object.removeClass('res-active');
                }
            },
            error: function (res) {
                console.log(res);
            }
        });
    });
});