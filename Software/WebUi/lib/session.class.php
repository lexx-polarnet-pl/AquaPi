<?

class Session {
        var $SID = NULL;                        // session unique ID
        var $_content = array();
        var $_updated = FALSE;                  // indicates that content has
                                                // been altered
        var $autoupdate = FALSE;                // do automatic update on each
                                                // save() or save_by_ref() ?

        function redirect($location)
        {
                $this->close();
                header('Location: '.$location);
                die;
        }

        function close()
        {
                //$this->_saveSession();
                $this->SID = NULL;
                $this->_content = array();
        }

        function _saveSession()
        {
                if($this->autoupdate || $this->_updated)
                        $this->DB->Execute('UPDATE sessions SET content = ?, mtime = ?NOW? WHERE id = ?', array(serialize($this->_content), $this->SID));
        }

}



?>