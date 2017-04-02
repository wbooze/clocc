;;; -*- Mode: Lisp -*-

;;; ecls.lisp --
;;; ECLS implementation (http://ecls.sf.net)

;;; Copyright (c) 2000-2005 Marco Antoniotti, all rights reserved.
;;; This software is released under the terms of the GNU Lesser General
;;; Public License (LGPL, see file COPYING for details).

(in-package "CL.ENV")

;;; Directory utilities

(defmethod current-directory-pathname ((cl-implementation cl.env:ecl))
  (pathname (si:getcwd)))


(defmethod change-current-working-directory ((cl-implementation cl.env:ecl)
					     (new-directory string))
  (si:chdir new-directory))


(defmethod change-current-working-directory ((cl-implementation cl.env:ecl)
					     (new-directory pathname))
  (si:chdir (namestring new-directory)))

 

;;; DEFSYSTEM utilities

;;; find-system

#|
(defmethod find-system ((sys symbol)
			(cl cl.env:ecl)
			(defsys-tag (eql :ecl)))
  nil)

(defmethod load-system ((sys symbol)
			(cl cl.env:allegro)
			(defsys-tag (eql :ecl))
			&rest keys)
  (apply #'ecl:load-system sys keys))
|#

;;; end of file -- ecls.lisp --
