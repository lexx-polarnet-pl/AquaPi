<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */

/**
 * Include the {@link shared.make_timestamp.php} plugin
 */
require_once(SMARTY_PLUGINS_DIR . 'shared.make_timestamp.php');
/**
 * Smarty utc date_format modifier plugin
 *
 * Type:     modifier<br>
 * Name:     utcdate_format<br>
 * Purpose:  format datestamps via gmstrftime<br>
 * Input:<br>
 *         - string: input date string
 *         - format: gmstrftime format for output
 *         - default_date: default date if $string is empty
 * @link http://smarty.php.net/manual/en/language.modifier.date.format.php
 *          date_format (Smarty online manual)
 * @param string
 * @param string
 * @param string
 * @return string|void
 * @uses smarty_make_timestamp()
 */
function smarty_modifier_utcdate_format($string, $format="%b %e, %Y", $default_date=null)
{
    if($string != '') {
        return gmstrftime($format, smarty_make_timestamp($string));
    } elseif (isset($default_date) && $default_date != '') {
        return gmstrftime($format, smarty_make_timestamp($default_date));
    } else {
        return;
    }
}

/* vim: set expandtab: */

?>
