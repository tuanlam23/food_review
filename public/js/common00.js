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


    $('body').on('click', '#load-page', function (event) {
        event.preventDefault();
        var page = $(this).attr('data-page');
        var url = $(this).attr('data-url');
        var object = $(this);
        $.ajax({
            url: url + "?page=" + page,
            type: "GET",
            dataType: 'json',
            success: function (res) {
                $('#list_res').append(res.content);
                object.attr('data-page', res.next_page)
                if(res.next_page > res.last_page){
                    object.hide();
                }
                if(res.next_page <= res.last_page){
                    object.show();
                }
            },
            error: function (res) {
                console.log(res);
            }
        });
    });


    $('body').on('click', '.vote', function (event) {
        var number_star = $(this).attr('id').split("_")[1];
        for (var i = 1; i <= number_star; i++){
            $('#star_' + i).removeClass('fa-star-o').addClass('fa-star');
        }
        for (var i = 5; i > number_star; i--){
            $('#star_' + i).removeClass('fa-star').addClass('fa-star-o');
        }
        $('#rate').val(number_star);

    });


    $('body').on('click', '#load-follow', function (e) {
        e.preventDefault();
        var url = $(this).attr('data-url');
        $(this).addClass('current');
        $('#load-new').removeClass('current');
        $.ajax({
            url: url,
            type: "GET",
            dataType: 'json',
            success: function (res) {
                $('#list_res').html(res.content);

                if(res.status == 274 || res.next_page > res.last_page){
                    $('#load-page').hide();
                }else
                {
                    alert(222);
                    $('#load-page').show();
                    $('#load-page').attr('data-page', res.next_page);
                    $('#load-page').attr('data-url', url);
                }
            },
            error: function (res) {
                console.log(res);
            }
        });
    });

    $('body').on('click', '#load-new', function (e) {
        e.preventDefault();
        var url = $(this).attr('data-url');
        $(this).addClass('current');
        $('#load-follow').removeClass('current');
        $.ajax({
            url: url,
            type: "GET",
            dataType: 'json',
            success: function (res) {
                $('#list_res').html(res.content);
                if(res.status == 274 || res.next_page > res.last_page){
                    $('#load-page').hide();
                }else
                {
                    $('#load-page').show();
                    $('#load-page').attr('data-page', res.next_page);
                    $('#load-page').attr('data-url', url);
                }
            },
            error: function (res) {
                console.log(res);
            }
        });
    });
});