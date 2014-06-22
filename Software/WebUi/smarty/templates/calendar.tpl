{include "header.tpl"}




<center>

<script>
    width	= screen.availWidth-200;
    height	= screen.availHeight-400;
    document.write('<iframe src="https://www.google.com/calendar/embed?showTitle=0&amp;showPrint=0&amp;showCalendars=0&amp;height=600&amp;wkst=2&amp;hl=pl&amp;bgcolor=%23eeeeee&amp;'+
		    'src={$calendar_id}'+
		    '&amp;color=%23182C57&amp;ctz=Europe%2FWarsaw" style=" border-width:0 " width="'+ 
		    width +'" height="'+ 
		    height +'" frameborder="0" scrolling="no"></iframe>');
</script>


</center>

{include "footer.tpl"}