#!/bin/bash

# Copyright 2015 Ankur Sinha 
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
#
# This program is free software: you can redistribute it and/or modify
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
rm ~/rpmbuild/SOURCES/rpmfusion-free*

cd packages
rsync -avPh --delete --exclude=repoview --exclude=repodata rsync://rsync.mirrorservice.org/download1.rpmfusion.org/free/fedora/development/22/x86_64/os/* .
cd ..

appstream-builder --verbose --max-threads=6 --log-dir=./logs/ \
--packages-dir=./packages/ --temp-dir=./tmp/ --output-dir=./appstream-data/ \
--basename="rpmfusion-free-22" \
--origin="rpmfusion-free-22" \
--include-failed \
--enable-hidpi \
--screenshot-uri="http://ankursinha.fedorapeople.org/rpmfusion-appdata/free/" \
--extra-appdata-dir="../rpmfusion-appdata/appdata-extra-free" > builderlog.txt

cp appstream-data/* ~/rpmbuild/SOURCES/

pushd ~/rpmbuild/SPECS
    #rpmdev-bumpspec -c "Added new files to extra repo." -u "Ankur Sinha <ankursinha AT fedoraproject DOT org>" rpmfusion-free-appstream-data.spec
    rm -rf ../RPMS/noarch/rpmfusion-free*
    rpmbuild -ba rpmfusion-free-appstream-data.spec
popd

cd appstream-data/
mkdir screenshots
cd screenshots
tar -xvf ../rpmfusion-free-22-screenshots.tar
rsync -avPh --delete ./* ankursinha@fedorapeople.org:./public_html/rpmfusion-appdata/free/

