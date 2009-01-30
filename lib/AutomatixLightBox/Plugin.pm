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


package AutomatixLightBox::Plugin;

use strict;

our $cache; #

sub buildc {
 my ($cb, %args) = @_;
 my $ref = $args{Content};
 my $content = $$ref;
 my $x;
 my $added = 0;
 foreach  $x  ($content =~ m/(<a\s[a-z0-9="' )(.\/-_,]*href=["'][^<]+\.(jpg|png)["'][a-z0-9="' )(.\/-_,]*>)/mgi) {   
   if(length($x) > 5) # we skip the subpatterns 
   {
     my $y = $x;
     $added = 1; #we need the scripts
     if ($y !~ m/rel\s*=\s*['"]/i) #skip it if rel is already set. -- for galleries
     {
       $y =~ s/<a/<a rel="lightbox"/i;
       $$ref =~ s/\Q$x\E/$y/mig;     
      }
    } 
 }
 if ($added) {
   $x = lightboxscripts($args{Context},'');
   $$ref =~ s|</head>|$x|;
 }
 return 1;   
} 

sub lightboxscripts {
  my ($ctx, $args) = @_;
  return $cache unless(!$cache);
  my $blog = $ctx->stash('blog'); 
  my $out = '<script src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.2/prototype.js" type="text/javascript"></script>';
  $out .= '<script src="http://ajax.googleapis.com/ajax/libs/scriptaculous/1.8.1/scriptaculous.js?load=effects,builder" type="text/javascript"></script>';
  $out .= '<script type="text/javascript" src="' . $blog->site_url .'/lightbox.js"></script>';
  $out .= '<link type="text/css" href="' . $blog->site_url . '/lightbox.css" rel="stylesheet" />'; 
  crea_plantilla('LightBoxJS','js.tmpl','lightbox.js',$blog); 
  crea_plantilla('LightBoxCSS','css.tmpl','lightbox.css',$blog);
  return $cache = $out;
}

sub crea_plantilla {
  my ($nombre,$tmpl,$archivo,$blog) = @_;
  use MT::Template;
  my $t =MT::Template->load({ blog_id=>$blog->id , name => $nombre});
  return 0 if (MT::Template->load({ blog_id=>$blog->id , name => $nombre})); #we exit if it already exists
  my $p = plugin();
  $t = $p->load_tmpl($tmpl);
  $t->name($nombre);
  $t->blog_id($blog->id);
  $t->type('index');
  $t->outfile($archivo);   
  $t->rebuild_me(1);  
  $t->save() or die $tmpl->errstr;
}

sub plugin {
  return MT->component("AutomatixLightBox");
}


1;