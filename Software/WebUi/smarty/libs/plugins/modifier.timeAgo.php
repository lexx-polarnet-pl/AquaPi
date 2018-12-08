<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty date modifier plugin
 * Purpose:  converts unix timestamps or datetime strings to words
 * Type:     modifier<br>
 * Name:     timeAgo<br>
 * @author   Stephan Otto
 * @param string
 * @return string
 */
function smarty_modifier_timeAgo( $date)
{
    // for using it with preceding 'temu' prefix
      $timeStrings = array(   'teraz',              //<- now or future posts :-)
                        'sekundę', 'sekundy', 'sekund',		// 1,2,3
                        'minutę','minuty', 'minut',      	// 4,5,6
                        'godzinę', 'godziny', 'godzin',  	// 7,8,9
                        'dzień', 'dni',         			// 10,11
                        'tydzień', 'tygodnie',      		// 12,13
                        'miesiąc', 'miesięce', 'miesięcy',	// 14,15,16      
                        'rok','lata','lat');      			// 17,18,19
      $debug = false;
      $sec = time() - (( strtotime($date)) ? strtotime($date) : $date);
      
      if ( $sec <= 0) return $timeStrings[0];
      
      if ( $sec < 2) return $sec." ".$timeStrings[1];
      if ( $sec < 5) return $sec." ".$timeStrings[2];
      if ( $sec < 60) return $sec." ".$timeStrings[3];
      
      $min = $sec / 60;
      if ( floor($min+0.5) < 2) return floor($min+0.5)." ".$timeStrings[4];
      if ( $min < 5) return floor($min+0.5)." ".$timeStrings[5];
      if ( $min < 60) return floor($min+0.5)." ".$timeStrings[6];
      
      $hrs = $min / 60;
      if ( floor($hrs+0.5) < 2) return floor($hrs+0.5)." ".$timeStrings[7];
      if ( $hrs < 5) return floor($hrs+0.5)." ".$timeStrings[8];	  
      if ( $hrs < 24) return floor($hrs+0.5)." ".$timeStrings[9];
      
      $days = $hrs / 24;
      if ( floor($days+0.5) < 2) return floor($days+0.5)." ".$timeStrings[10];
      if ( $days < 7) return floor($days+0.5)." ".$timeStrings[11];
      
      $weeks = $days / 7;
      if ( floor($weeks+0.5) < 2) return floor($weeks+0.5)." ".$timeStrings[12];
      if ( $weeks < 4) return floor($weeks+0.5)." ".$timeStrings[13];
	  
      
      $months = $weeks / 4;
      if ( floor($months+0.5) < 2) return floor($months+0.5)." ".$timeStrings[14];
      if ( $months < 5) return floor($months+0.5)." ".$timeStrings[15];	  
      if ( $months < 12) return floor($months+0.5)." ".$timeStrings[16];
      
      $years = $weeks / 51;
      if ( floor($years+0.5) < 2) return floor($years+0.5)." ".$timeStrings[17];
      if ( $years < 5) return floor($months+0.5)." ".$timeStrings[18];	 	  
      return floor($years+0.5)." ".$timeStrings[19];
}

?>