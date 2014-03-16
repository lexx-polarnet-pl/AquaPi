/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
 * USA.
 *
 * $Id:$
 */

#include "inih/ini.h"
#include "inih/ini.c"

static int handler(void* user, const char* section, const char* name, const char* value)
{
    configuration* pconfig = (configuration*)user;

    #define MATCH(s, n) strcmp(section, s) == 0 && strcmp(name, n) == 0
    if (MATCH("database", "host")) {
        pconfig->db_host = strdup(value);
    } else if (MATCH("database", "user")) {
        pconfig->db_user = strdup(value);
    } else if (MATCH("database", "password")) {
        pconfig->db_password = strdup(value);
    } else if (MATCH("database", "database")) {
        pconfig->db_database = strdup(value);
    } else if (MATCH("daemon", "dontfork")) {
        pconfig->dontfork = atoi(value);
    } else if (MATCH("daemon", "temp_freq")) {
        pconfig->temp_freq = atoi(value);
    } else if (MATCH("daemon", "stat_freq")) {
        pconfig->stat_freq = atoi(value);
    } else if (MATCH("daemon", "devel_freq")) {
        pconfig->devel_freq = atoi(value);
    } else if (MATCH("daemon", "reload_freq")) {
        pconfig->reload_freq = atoi(value);		
    } else if (MATCH("daemon", "dummy_temp_sensor")) {
        pconfig->dummy_temp_sensor_val = atof(value);
    } else if (MATCH("daemon", "bind_address")) {
        pconfig->bind_address = strdup(value);		
    } else if (MATCH("daemon", "bind_port")) {
        pconfig->bind_port = atoi(value);		
    } else {
        return 0;  /* unknown section/name, error */
    }
    return 1;
}
