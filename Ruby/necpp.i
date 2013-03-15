%module necpp
/* Part of the Ruby binding code for nec2++ 
  Copyright (C) 2008-2010 Tim Molteno. tim@physics.otago.ac.nz
  Released under the GPL v3.
*/
%{
#include "../src/libnecpp.h"
#include "../src/nec_exception.h"
%}

/* Handle exceptions thrown by nec2++ */
%exception {
 try {
 $action
 }
 catch (nec_exception* e) {
 static VALUE cpperror = rb_define_class("CPPError", rb_eStandardError);
 rb_raise(cpperror, "%s", e->get_message().c_str());
 }
}

%include "typemaps.i"

/* Used for functions that output a new opaque pointer */
%typemap(in,numinputs=0) opaque_t *OUTPUT (opaque_t retval)
{
 /* OUTPUT in */
    retval = NULL;
    $1 = &retval;
}

/* used for functions that take in an opaque pointer (or NULL)
and return a (possibly) different pointer */
%typemap(argout) opaque_t *OUTPUT, opaque_t *INOUT
{
 /* OUTPUT argout */
  %append_output(SWIG_NewPointerObj(SWIG_as_voidptr(retval$argnum), $1_descriptor, 0));
}

%typemap(in) opaque_t *INOUT (opaque_t retval)
{
   /* INOUT in */
   SWIG_ConvertPtr(obj1,SWIG_as_voidptrptr(&retval), 0, 0);
    $1 = &retval;
}

/* No need for special IN typemap, it works anyway */

%include "../src/libnecpp.h"
