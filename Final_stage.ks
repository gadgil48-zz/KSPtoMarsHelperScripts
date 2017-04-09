declare parameter ap_setpoint.
declare parameter headng.

lock vs to ship:verticalspeed.

lock throttle to 1.

set setpoint to ap_setpoint*1000.

set Kp to 0.005379.
set Ki to 0.0001355.
set Kd to 0.03819/8.214.

set PitchPID to PIDLOOP(Kp, Ki, Kd).
set PitchPID:minoutput to -30.
set PitchPID:maxoutput to 30.

set start_time to time:seconds.

set steertag to heading(headng, 0).

lock steering to steertag.

until vs<0{
      set error to orbit:apoapsis-setpoint.

      set cur_time to time:seconds - start_time.

      set pitch to PitchPID:update(cur_time, error).

      set steertag to heading(headng, pitch).

      log cur_time+ " " + error + " " + pitch to final2.txt.

      clearscreen.

      print "Apoapsis: " + orbit:apoapsis + "m" at (0,1).

      print "Pitch: " + pitch + "deg" at (0,3).
      
      wait 0.
}


until (setpoint-orbit:periapsis)<10000{

      set vorbh to (ship:velocity:orbit-ship:velocity:surface):mag+ship:groundspeed.

      set centrifugal_acc to vorbh*vorbh/(orbit:body:radius+ship:altitude).

      set grav_acc to orbit:body:mu/((orbit:body:radius+ship:altitude)^2).

      set effec_acc to grav_acc-centrifugal_acc.

      set pitch to MAX(-30, MIN(30,arcsin(effec_acc/(ship:availablethrust/ship:mass)))).

      set steertag to heading(headng, pitch).

      clearscreen.

      print "Altitude: " + ship:altitude + "m" at (0,1).

      print "Pitch: " + pitch + "deg" at (0,3).

      wait 0.
}

lock throttle to 0.
unlock steering.
