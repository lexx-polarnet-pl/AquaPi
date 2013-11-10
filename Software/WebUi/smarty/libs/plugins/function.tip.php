<?php

function smarty_function_tip($args, &$SMARTY)
{
//new dBug($args);
	if ($popup = $args['dynpopup']) 
	{
		if(is_array($args))
			foreach($args as $argid => $argval)
				$popup = str_replace('$'.$argid, $argval, $popup);
		$text = "onmouseover=\"return overlib('<iframe id=&quot;autoiframe&quot; width=100 height=10 frameborder=0 scrolling=no src=&quot;".$popup."&popup=1&quot;></iframe>',HAUTO,VAUTO,OFFSETX,30,OFFSETY,15".($args['sticky'] ? ',STICKY, MOUSEOFF' : '').");\" onmouseout=\"nd();\"";
//		global $SESSION;
//		$text = 'onmouseover="if(getSeconds() < '.$SESSION->timeout.'){ return overlib(\'<iframe id=&quot;autoiframe&quot; frameborder=0 scrolling=no width=220 height=150 src=&quot;'.$popup.'&quot;></iframe>\',HAUTO,VAUTO,OFFSETX,85,OFFSETY,15); }" onmouseout="nd();"';
		return $text;
	} 
	else if ($popup = $args['popup']) 
	{
		if(is_array($args))
			foreach($args as $argid => $argval)
				$popup = str_replace('$'.$argid, $argval, $popup);
		$text = " onclick=\"return overlib('<iframe id=&quot;autoiframe&quot; width=100 height=10 frameborder=0 scrolling=no src=&quot;".$popup."&popup=1&quot;></iframe>',HAUTO,VAUTO,OFFSETX,10,OFFSETY,10);\" onmouseout=\"nd();\" ";
		return $text;
	} 
	else 
	{
	    if($SMARTY->_tpl_vars['error'][$args['trigger']])
	    {
		    $error = str_replace("'",'\\\'',$SMARTY->_tpl_vars['error'][$args['trigger']]);
		    $error = str_replace('"','&quot;',$error);
		    $error = str_replace("\r",'',$error);
		    $error = str_replace("\n",'<BR>',$error);
		    
		    $result = ' onmouseover="return overlib(\'<b><font color=red>'.$error.'</font></b>\',HAUTO,VAUTO,OFFSETX,15,OFFSETY,15);" onmouseout="nd();" ';
		    $result .= $args['bold'] ? ' CLASS="alert bold" ' : ' CLASS="alert" ';
	    }
	    elseif($args['text'] != '') 
	    {
		    $text = $args['text'];
    		    if($SMARTY->_tpl_vars['_LANG'][$text])
	    		    $text = trim($SMARTY->_tpl_vars['_LANG'][$text]);

		    if(is_array($args))
			    foreach($args as $argid => $argval)
				    $text = str_replace('$'.$argid, $argval, $text);

		    $text = str_replace("'",'\'',$text);
		    $text = str_replace('"','&quot;',$text);
		    $text = str_replace("\r",'',$text);
		    $text = str_replace("\n",'<BR>',$text);
		    
		    $width= strlen($text)/4;
		    if($width<100)
			$width=100;
//		    elseif($width>600)
//			$width=600;
		    $result .= 'onmouseover="return overlib(\''.substr($text,0,1500).'\',HAUTO,VAUTO,OFFSETX,15,OFFSETY,15,WIDTH,'.$width.');" onmouseout="nd();"';
		    $result .= $args['bold'] ? ' CLASS="bold" ' : '';
	    }
	    
	    return $result;
	}
}

?>
