<?php
/**
 * @package WordPress
 * @subpackage Default_Theme
 */

get_header(); ?>

        <div id="content">

			<?php if (have_posts()) : ?>
        
                <?php while (have_posts()) : the_post(); ?>
        
                    <article class="blog">
                        <h1><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title_attribute(); ?>"><?php the_title(); ?></a></h1>
                        <?php the_content('Read the rest of this entry &raquo;'); ?>
                        <p><?php comments_popup_link('What do you think?', '1 Thought &#187;', '% Thoughts &#187;'); ?></p>
                    </article>

        
                <?php endwhile; ?>
        
            <?php else : ?>
        
                    <article>
                        <h1>Not Found</h1>
                        <p class="center">Sorry, but you are looking for something that isn't here.</p>
                        <?php get_search_form(); ?>
					</article>
        
            <?php endif; ?>
            
                    <aside class="blog">
                        <ul>
                            <?php 	/* Widgetized sidebar, if you have the plugin installed. */
                                    if ( !function_exists('dynamic_sidebar') || !dynamic_sidebar() ) : ?>
                        </ul>
                        <ul>
                
                            <li><h2>Archives</h2>
                                <ul>
                                <?php wp_get_archives('type=monthly'); ?>
                                </ul>
                            </li>
                
                            <?php wp_list_categories('show_count=1&title_li=<h2>Categories</h2>'); ?>
                            
                        </ul>
                
                            <?php endif; ?>
                        <ul style="margin-top:20px;">
                            <li><h2><a href="http://www.twitter.com/ksmoot" target="_blank">Follow Us On Twitter</a></h2>
                                
                                    <?php echo do_shortcode('[twitter-feed username="ksmoot" id="14203854" num="5" followlink="no" linklove="no" timeline="yes" liclass="tweet"]'); ?>
                               
                            </li>        
                        </ul>
                    </aside>            

        </div>

		<div>
			<div class="alignleft"><?php next_posts_link('&laquo; Older Entries') ?></div>
			<div class="alignright"><?php previous_posts_link('Newer Entries &raquo;') ?></div>
		</div>

<?php get_footer(); ?>