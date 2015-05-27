#!/bin/bash

# Copyright 2015 Ankur Sinha 
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
#
# This program is nonfree software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# File : 
#

rm appstream-data/* -rf
rm ~/rpmbuild/SOURCES/rpmfusion-nonfree*

cd packages
rsync -avPh --delete rsync://rsync.mirrorservice.org/download1.rpmfusion.org/nonfree/fedora/development/22/x86_64/os/* .
cd ..

appstream-builder --verbose --max-threads=6 --log-dir=./logs/ \
--packages-dir=./packages/ --temp-dir=./tmp/ --output-dir=./appstream-data/ \
--basename="rpmfusion-nonfree-22" \
--origin="rpmfusion-nonfree-22" \
--include-failed \
--enable-hidpi \
--screenshot-uri="http://ankursinha.fedorapeople.org/rpmfusion-appdata/nonfree/" \
--extra-appdata-dir="../rpmfusion-appdata/appdata-extra-nonfree"

cp appstream-data/* ~/rpmbuild/SOURCES/

cd appstream-data/
mkdir screenshots
cd screenshots
tar -xvf ../rpmfusion-nonfree-22-screenshots.tar
rsync -avPh --delete ./* ankursinha@fedorapeople.org:./public_html/rpmfusion-appdata/nonfree/
