#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>

####
#### AutomatixLightBox for MT and MTOS 
#### Copyright 2008 Mixel Adm  
#### http://mixelandia.com


package AutomatixLightBox::Entry;
use strict;

sub xfrm_edit {
    my ($cb, $app, $param, $tmpl) = @_;
    
	 my $type = $param->{object_type};
     my $class = $app->model($type);
     if (!$class) {		
		return 1; # fail gracefully
    }
	 my $obj = $class->load($param->{id});
	my $valor = ($obj->as_gallery)?'checked ="checked"':'';
	my $setting = $tmpl->createElement('app:setting', { 
	id => 'as_gallery', label => "Lightbox Gallery" });
    $setting->innerHTML('<input type="checkbox" name="as_gallery" value="1"' . $valor .'>' );
    return $tmpl->insertAfter($setting,$tmpl->getElementById('authored_on'));
	
}


sub pre_save {
    
    my ($cb, $app, $obj, $orig) = @_;
    my $blog = $app->blog;
    my $aux = $app->param('as_gallery');
	MT->log({message => $aux});
    $obj->as_gallery($aux);
    1;
}


1;