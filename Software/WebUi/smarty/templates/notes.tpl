{include "header.tpl"}

{literal}

<style type="text/css">

h2,p{
  font-size:100%;
  font-weight:normal;
}
ul,li{
  list-style:none;
}
ul{
  overflow:hidden;
  padding:3em;
}
ul li a{
  text-decoration:none;
  background:#ffc;
  display:block;
  height:10em;
  width:10em;
  padding:1em;
  -moz-box-shadow:5px 5px 7px rgba(33,33,33,1);
  -webkit-box-shadow: 5px 5px 7px rgba(33,33,33,.7);
  box-shadow: 5px 5px 7px rgba(33,33,33,.7);
  -moz-transition:-moz-transform .15s linear;
  -o-transition:-o-transform .15s linear;
  -webkit-transition:-webkit-transform .15s linear;
}
ul li{
  margin:1em;
  float:left;
}
ul li h2{
  font-size:140%;
  font-weight:bold;
  padding-bottom:10px;
}
ul li p{
  font-family:"Reenie Beanie",arial,sans-serif;
  font-size:180%;
}
ul li a{
  -webkit-transform: rotate(-6deg);
  -o-transform: rotate(-6deg);
  -moz-transform:rotate(-6deg);
}
ul li:nth-child(even) a{
  -o-transform:rotate(4deg);
  -webkit-transform:rotate(4deg);
  -moz-transform:rotate(4deg);
  position:relative;
  top:5px;
  background:#cfc;
}
ul li:nth-child(3n) a{
  -o-transform:rotate(-3deg);
  -webkit-transform:rotate(-3deg);
  -moz-transform:rotate(-3deg);
  position:relative;
  top:-5px;
  background:#ccf;
}
ul li:nth-child(5n) a{
  -o-transform:rotate(5deg);
  -webkit-transform:rotate(5deg);
  -moz-transform:rotate(5deg);
  position:relative;
  top:-10px;
}
ul li a:hover,ul li a:focus{
  box-shadow:10px 10px 7px rgba(0,0,0,.7);
  -moz-box-shadow:10px 10px 7px rgba(0,0,0,.7);
  -webkit-box-shadow: 10px 10px 7px rgba(0,0,0,.7);
  -webkit-transform: scale(1.25);
  -moz-transform: scale(1.25);
  -o-transform: scale(1.25);
  position:relative;
  z-index:5;
}
ol{text-align:center;}
ol li{display:inline;padding-right:1em;}
ol li a{color:#fff;}

.black_overlay{
    display: none;
    position: absolute;
    top: 0%;
    left: 0%;
    width: 100%;
    height: 100%;
    background-color: black;
    z-index:1001;
    -moz-opacity: 0.8;
    opacity:.80;
    filter: alpha(opacity=80);
}

.white_content {
    display: none;
    position: absolute;
    top: 25%;
    left: 25%;
    width: 50%;
    height: 50%;
    padding: 16px;
    border: 16px solid orange;
    background-color: white;
    z-index:1002;
    overflow: auto;
}

.pin {
    border-radius: 50%;
    width: 20px;
    height: 20px;
    -webkit-box-shadow: 0 3px 6px rgba(0,0,0,.55);
    -moz-box-shadow: 0 3px 6px rgba(0,0,0,.55);
    box-shadow: 0 3px 6px rgba(0,0,0,.55);
    margin: 0 auto;
    margin-top: 2px;
    background-image: -moz-radial-gradient(45px 45px 45deg, circle cover, yellow 50%, black 100%);
    background-image: -webkit-radial-gradient(45px 45px, circle cover, red, black);
    background-image: radial-gradient(red 50%, black 100%);
    transform: rotate(-3.5deg);
    -webkit-transform: rotate(-3.5deg);
    -moz-transform: rotate(-3.5deg);
    background-color: #CBFAFA;
}
</style>


{/literal}

<p>
	<a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'">Nodaj notatkę</a>
</p>

<div id="light" class="white_content">
	<form action="notes.php?action=add" method="post">
		Tytuł: <input class="medium" type="text" name="title" id="title" value="" /><BR>
		Notatka: <input class="medium" type="text" name="content" id="content" value="" /><BR>
		<INPUT TYPE="image" SRC="img/submit.png" align="right">
	</form>
	<a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'">Close</a>
</div>
<div id="fade" class="black_overlay"></div>

<ul>
    {foreach from=$notes item=note}
	<li>
    	    <a href="#">
		<div class='pin' onclick="location.href = 'notes.php?action=delete&id={$note.note_id}';"></div>
    		<h2>{$note.note_title}</h2>
    		<p>{$note.note_content}</p>
    	    </a>
    </li>

    {/foreach}
</ul>

{include "footer.tpl"}