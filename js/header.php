<?php
/**
 * The Header for the template.
 *
 * @package WordPress
 * @subpackage Pai
 */
?><!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
<meta charset="<?php bloginfo( 'charset' ); ?>" />
<title><?php wp_title('&lsaquo;', true, 'right'); ?><?php bloginfo('name'); ?></title>
<link rel="stylesheet" type="text/css" media="all" href="<?php bloginfo( 'stylesheet_url' ); ?>" />

<?php $pp_favicon = get_option('pp_favicon'); ?>
<link rel="shortcut icon" href="<?php echo $pp_favicon; ?>" />

<!-- Template stylesheet -->
<link rel="stylesheet" href="<?php bloginfo( 'stylesheet_directory' ); ?>/css/jqueryui/custom.css" type="text/css" media="all"/>
<link rel="stylesheet" href="<?php bloginfo( 'stylesheet_directory' ); ?>/css/screen.css" type="text/css" media="all"/>
<link rel="stylesheet" type="text/css" href="<?php bloginfo( 'stylesheet_directory' ); ?>/js/fancybox/jquery.fancybox-1.3.0.css" media="screen"/>

<!--[if IE]>
<link rel="stylesheet" href="<?php bloginfo( 'stylesheet_directory' ); ?>/css/ie.css" type="text/css" media="all"/>
<![endif]-->

<!--[if IE 7]>
<link rel="stylesheet" href="<?php bloginfo( 'stylesheet_directory' ); ?>/css/ie7.css" type="text/css" media="all"/>
<![endif]-->

<!-- Jquery and plugins -->
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/jquery.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/jquery-ui.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/fancybox/jquery.fancybox-1.3.0.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/jquery.easing.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/anythingSlider.js"></script>

<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/jquery.validate.js"></script>

<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/hint.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/browser.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/custom.js"></script>
<script type="text/javascript" src="<?php bloginfo( 'stylesheet_directory' ); ?>/js/rollover.js"></script>

<!-- PRETTY PHOTO-->
<link rel="stylesheet" href="<?php bloginfo( 'stylesheet_directory' ); ?>/prettyPhoto/css/prettyPhoto.css" type="text/css" media="screen" />
<script src="<?php bloginfo( 'stylesheet_directory' ); ?>/prettyPhoto/js/jquery.prettyPhoto.js" type="text/javascript"></script>

<?php wp_head(); ?>

<?php
if(is_front_page())
{
?>
<script>
$(document).ready(function(){ 
	$('#menu_wrapper .menu-main-menu-container .nav li a[title=Home]').parent('li').addClass('current-menu-item');
});
</script>
<?php
}
?>

</head>

<?php

/**
*	Get Current page object
**/
$page = get_page($post->ID);


/**
*	Get current page id
**/
$current_page_id = '';

if(isset($page->ID))
{
    $current_page_id = $page->ID;
}

?>

<body <?php body_class(); ?>>
<!-- Begin header -->
<div id="header_wrapper">
  <div id="top_bar">
    <div class="logo">
      <!-- Begin logo -->
      <?php
		//get custom logo
		$pp_logo = get_option('pp_logo');
		
	  ?>
      <a id="custom_logo" href="<?php bloginfo( 'url' ); ?>"><img src="<?php echo $pp_logo?>" alt=""/></a>
      <!-- End logo -->
    </div>
    <!-- Begin main nav -->
    <div id="menu_wrapper">
      <?php 	
					    			//Get page nav
					    			wp_nav_menu( 
					    					array( 
					    						'menu_id'			=> 'main_menu',
					    						'menu_class'		=> 'nav',
					    						'theme_location' 	=> 'primary-menu',
					    					) 
					    			); 
					    ?>
    </div>
    <!-- End main nav -->
  </div>
</div>
<!-- End header -->
<br class="clear"/>
