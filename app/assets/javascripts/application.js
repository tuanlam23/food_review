// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .

$(document).on("turbolinks:load", function () {
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

    $('body').on('keypress', '.comment', function (e) {
        var object = $(this)
        if(e.which === 13){
            var content = $(this).val();
            var review_id = $(this).attr('data-review');
            var url = $(this).attr('data-url');
            console.log(url);
            if(content == ""){
                alert('Nội dung thảo luận trống');
            }else {
                $.ajax({
                    url: url,
                    type: "POST",
                    dataType: 'json',
                    data: {review_id: review_id, content: content},
                    success: function (res) {
                        $("#comments_" + review_id).append(res.content);
                        object.val("");
                    },
                    error: function (res) {
                        console.log(res);
                    }
                });
            }
            return false;
        }
    });

    $('body').on('click', '#area-box a', function (e) {
        e.preventDefault();
        $("#district").show();
        $("#area-box").addClass('search-active');
        $("#cate-box").removeClass("search-active");
        $("#category").hide();
    });
    $('body').on('click', '#cate-box a', function (e) {
        e.preventDefault();
        $("#district").hide();
        $("#area-box").removeClass('search-active');
        $("#cate-box").addClass("search-active");
        $("#category").show();
    });

    $('body').on("click", ".dropdown-menu", function (e) {
        e.stopPropagation();
    });

    $('body').on("change", "#city", function () {
        var city = $(this).children("option:selected").val();
        window.location = "/?city=" + city;
    });

});