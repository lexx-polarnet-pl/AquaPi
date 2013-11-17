<?

//new dBug($CONFIG['plugins']);
//
//$relays     = $db->GetAll('SELECT * FROM interfaces
//                            WHERE interface_deviceid IN (
//                                    SELECT device_id
//                                    FROM devices
//                                    WHERE device_name = ?)', array( 'relayboard' ));
//
//new dBug($interfaces['relayboard']);
//
//foreach ($interfaces['relayboard'] as $relay)
//{
//    //new dBug($relay);
//    $relayboard[]=$db->GetRow('SELECT *, stat_value XOR ? as interface_enable, ? as interface_addressshort FROM stats s
//                                    WHERE stat_interfaceid = ?
//                                    AND stat_date IN (
//                                        SELECT MAX( stat_date ) 
//                                        FROM stats st
//                                        WHERE st.stat_interfaceid = s.stat_interfaceid)
//                                        ', array($relay['interface_conf'], $relay['interface_addressshort'], $relay['interface_id'])
//                                );
//}

//new dBug($relayboard);

//$relayboard = $db->GetAll('SELECT *, relay_type XOR relay_state as relay_enable FROM relayboard');
//$smarty->assign('relayboard', $relayboard);

//new dBug($relayboard);

?>
