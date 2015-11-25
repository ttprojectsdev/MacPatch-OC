#!/bin/sh

#  cmd.sh
#  Mac Patch ReDux
#
#  Created by chris conley on 11/24/15.
#  Copyright © 2015 Chris Conley. All rights reserved.
if groups $whoami | grep -q -w admin
then
whoami
else
echo 0
fi