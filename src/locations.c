#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include <linux/limits.h>

// class stuff
#include "globals.h"
#include "libspm.h"
#include "cutils.h"

long get_locations(char*** locations, const char *loc_dir) {
  // Get package file location
  char files_location_cmd[PATH_MAX + 64];
  sprintf(files_location_cmd,"( cd %s && find . -type f | cut -c2- ) ", loc_dir);
  /*
  This way of getting locations is pretty bad , i should wite a proper way to do
  it But it works so its ok for now
  */
  dbg(2, "Getting files locations with %s ", files_location_cmd);

  // execute the commands
  // WARING : this is a memory leak
  char* res = exec(files_location_cmd);

  dbg(3, "Got locations : '%s'", res);
  
  unsigned int count = splita(res, '\n', locations);

  dbg(2, "Got %d locations", count);


  return count;
}