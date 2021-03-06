// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require underscore-min
//= require gmaps/google
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

var ready;
ready = function() {

    var panels = $('.user-infos');
    var panelsButton = $('.dropdown-user');
    panels.hide();

    //Click dropdown
    panelsButton.click(function() {
        //get data-for attribute
        var dataFor = $(this).attr('data-for');
        var idFor = $(dataFor);

        //current button
        var currentButton = $(this);
        idFor.slideToggle(400, function() {
            //Completed slidetoggle
            if(idFor.is(':visible'))
            {
                currentButton.html('<i class="glyphicon glyphicon-chevron-up text-muted"></i>');
            }
            else
            {
                currentButton.html('<i class="glyphicon glyphicon-chevron-down text-muted"></i>');
            }
        })
    });


    $('[data-toggle="tooltip"]').tooltip();

    $('button').click(function(e) {
        e.preventDefault();
    });
    // Function to load and show map
    $('a.show_map_btn').click(function(event) {
        event.preventDefault();

        gmapDiv = $(this).data('target');
        showMapPath = $(this).attr('href');
        map_btn = $(this);

        if (map_btn.hasClass("map_loaded"))
        {
            console.log( "Map is loaded previously." );
        }else{
            $.get( showMapPath, function( data ) {
                $(gmapDiv).html( data );
                map_btn.addClass('map_loaded');
                console.log( "Load was performed." );
            });
        }



    });

};

$(document).ready(ready);
$(document).on('page:load', ready);