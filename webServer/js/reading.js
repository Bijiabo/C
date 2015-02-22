/**
 * Created by bijiabo on 15/1/30.
 */

var settings = {
    audioElementId : "audio",
    playButtion : undefined,
    bookmarkButton : undefined
}
var cache = {};

var getJSON = function(contentDataFileName,timeDataFileName,callback){
    $.getJSON("data/"+contentDataFileName,function(contentData){
        $.getJSON("data/"+timeDataFileName,function(timeData){
            callback(contentData,timeData);
        });
    });
}

var reading = function(contentData,timeData,audioElementId){
    if(contentData && timeData)
    {
        this.contentData = contentData;
        this.diaplayContentData();

        this.timeData = timeData;
        this.audio = $("#"+audioElementId).get(0);
        this.audio.preload = true;
        this.addObserver();
    }
    else
    {
        console.log("数据获取失败。");
    }
};

reading.prototype.diaplayContentData = function(){
    for(var i= 0,len=this.contentData.length;i<len;i++)
    {
        var container = $("#content");
        switch (this.contentData[i].type)
        {
            case "chapter":
                container = $("#chapter");
                break;

            case "title":
                container = $("#title");
                break;

            default :
                break;
        }

        container.append('<span data-index="'+this.contentData[i].Index+'" class="sound-text">'+this.contentData[i].Text+'</span>');
    }
};

reading.prototype.addObserver = function(){
    var self = this;

    var textTracks = this.audio.textTracks;
    var textTrack = textTracks[0]; // corresponds to the first track element

    var kind = textTrack.kind; // e.g. "subtitles"
    var mode = textTrack.mode;
    var cues = textTrack.cues;

    /*
    var cue = cues[0]; // corresponds to the first cue in a track src file
    //var cueId = cue.id; // cue.id corresponds to the cue id set in the WebVTT file
    var cueText = cue.text;
    */

    textTrack.oncuechange = function (){
        // "this" is a textTrack
        var cue = this.activeCues[0]; // assuming there is only one active cue
        if(cue)
        {
            //alert("oncuechange!");
            var obj = JSON.parse(cue.text);
            if(obj.index)
            {
                if(obj.index.constructor.toString().match("Number"))
                {
                    self.highlight(obj.index);
                }
            }
        }
        //var obj = JSON.parse(cue.text);
        // do something
    }
};

reading.prototype.scrollActive = function(activeItem){
    $.smoothScroll({
        scrollTarget : activeItem,
        easing: 'swing',
        speed: 200,
        preventDefault: true,
        offset: 100
    });
};

reading.prototype.highlight = function(index){
    var hightItem = $(".sound-text.highlight");
    if(hightItem.data("index") != index)
    {
        hightItem.addClass("normal");
        var clearHighlight = function(element){
            return (function(){
                element.removeClass('highlight normal');
            });
        };
        var clearHightlightFunc = clearHighlight(hightItem);
        window.setTimeout(clearHightlightFunc,1000);

        var activeItem = $(".sound-text[data-index='"+index+"']");
        activeItem.addClass("highlight");

        this.scrollActive(activeItem);
    }
};

reading.prototype.seekTo = function(index){
    for(var i= 0,len=this.timeData.length;i<len;i++)
    {
        if(this.timeData[i].Index == index)
        {
            var time = this.timeData[i].StartTime / 1000;
            this.audio.currentTime = time;
            if(this.audio.paused)
            {
                playController.togglePlayButtonState("play");

            }
            //this.highlight(index);
            break;
        }
    }
};

reading.prototype.play = function(){
    var timeCache = 0,
        indexCache = 0;
    for(var i= 0,len=this.timeData.length;i<len;i++)
    {
        var time = this.timeData[i].StartTime / 1000;
        if(this.audio.currentTime > time)
        {
            timeCache = time;
            indexCache = this.timeData[i].Index;
        }
        else
        {
            break;
        }
    }

    this.audio.currentTime = timeCache;
    this.audio.play();
};

var addTextTrackToAudio = function(){
    var audio = $("#audio").get(0);
    var startTime, endTime, message;
    var newTextTrack = audio.addTextTrack("captions", "sample");
    newTextTrack.mode = newTextTrack.SHOWING; // set track to display
    // create some cues and add them to the new track
    for (var i = 0; i < 30; i++) {
        startTime = i * 5;
        endTime = ((i * 5) + 5);
        message = "This is number " + i;
        var TTC = new TextTrackCue(startTime, endTime, message);
        newTextTrack.addCue(TTC);
    }
    audio.play();
};

var playController = {
    togglePlayButtonState : function(state){
        settings.playButtion.data("state",state);
        if(state === "play")
        {

            cache.reading.play();
            settings.playButtion.addClass("fa-pause").removeClass("fa-play");
        }
        else
        {
            cache.reading.audio.pause();
            settings.playButtion.addClass("fa-play").removeClass("fa-pause");
        }
    }
}

$(function(){
    if(window.location.hash === "#debug")
    {
        $("#" + settings.audioElementId).show();
    }
    else
    {
        $("#" + settings.audioElementId).hide();
    }
    settings.playButtion = $("#play-button");
    settings.bookmarkButton = $("#bookmark-button");

    getJSON("Chapter4.Text.json","Chapter4.Time.json",function(contentData,timeData){
        cache.reading = new reading(contentData,timeData,settings.audioElementId);
    });

    $(document).on("tap",".sound-text",function(){
        var index = $(this).data("index");
        cache.reading.seekTo(index);
    });

    $(document).on("tap","#play-button",function(){
        if(cache.reading)
        {
            var self = $(this);
            if(self.data("state") === "pause")
            {
                cache.reading.audio.play();
                playController.togglePlayButtonState("play");
            }
            else
            {
                playController.togglePlayButtonState("pause");
            }
        }
    });
});