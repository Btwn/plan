u s e   [ i n t e l i s i s t m p ] 
 a l t e r   f u n c t i o n   [ d b o ] . [ f n _ m a v i r m 0 9 0 6 c o b x p o l ]   ( @ i d   i n t ) 
 r e t u r n s   v a r c h a r ( 1 0 ) 
 a s 
 b e g i n 
 d e c l a r e   @ c o b   v a r c h a r ( 1 0 ) , 
 @ d v   i n t , 
 @ d i   i n t , 
 @ d v e c   i n t , 
 @ d i n a c   i n t , 
 @ s e c c   v a r c h a r ( 5 0 ) , 
 @ c l i e n t e   v a r c h a r ( 1 0 ) , 
 @ q u i n c e n a   i n t , 
 @ y e a r   i n t   =   y e a r ( g e t d a t e ( ) ) 
 s e l e c t 
 @ c l i e n t e   =   c . c l i e n t e , 
 @ s e c c   =   i s n u l l ( c e . s e c c i o n c o b r a n z a m a v i ,   ' ' ) , 
 @ d v e c   =   i s n u l l ( c m . d i a s v e n c a c t m a v i ,   0 ) , 
 @ d i n a c   =   i s n u l l ( c m . d i a s i n a c a c t m a v i ,   0 ) 
 f r o m   c x c m a v i   c m   w i t h   ( n o l o c k ) 
 j o i n   c x c   c   w i t h   ( n o l o c k ) 
 o n   c . i d   =   c m . i d 
 j o i n   t a b l a s t d   t   w i t h   ( n o l o c k ) 
 o n   t . t a b l a s t   =   ' m o v i m i e n t o s   c o b r o   x   p o l i t i c a ' 
 a n d   t . n o m b r e   =   c . m o v 
 l e f t   j o i n   c t e e n v i a r a   c e   w i t h   ( n o l o c k ) 
 o n   c e . i d   =   c . c l i e n t e e n v i a r a 
 a n d   c e . c l i e n t e   =   c . c l i e n t e 
 w h e r e   c m . i d   =   @ i d 
 i f   i s n u l l ( @ c l i e n t e ,   ' ' )   ! =   ' ' 
 a n d   i s n u l l ( @ s e c c ,   ' ' )   ! =   ' i n s t i t u c i o n e s ' 
 a n d   ( i s n u l l ( @ d v e c ,   0 )   >   0 
 o r   i s n u l l ( @ d i n a c ,   0 )   >   0 ) 
 b e g i n 
 s e t   @ q u i n c e n a   = 
 c a s e 
 w h e n   d a y ( g e t d a t e ( ) )   >   1 6   t h e n   m o n t h ( g e t d a t e ( ) )   *   2 
 e l s e   ( m o n t h ( g e t d a t e ( ) )   *   2 )   -   1 
 e n d 
 s e t   @ q u i n c e n a   = 
 c a s e 
 w h e n   d a y ( g e t d a t e ( ) )   =   1   t h e n   @ q u i n c e n a   -   1 
 e l s e   @ q u i n c e n a 
 e n d 
 s e l e c t 
 @ y e a r   = 
 c a s e 
 w h e n   d a y ( g e t d a t e ( ) )   =   1   a n d 
 m o n t h ( g e t d a t e ( ) )   =   1   t h e n   @ y e a r   -   1 
 e l s e   @ y e a r 
 e n d , 
 @ q u i n c e n a   = 
 c a s e 
 w h e n   d a y ( g e t d a t e ( ) )   =   1   a n d 
 m o n t h ( g e t d a t e ( ) )   =   1   t h e n   2 4 
 e l s e   @ q u i n c e n a 
 e n d 
 s e l e c t   t o p   1 
 @ d v   =   i s n u l l ( c o n . d v ,   0 ) , 
 @ d i   =   i s n u l l ( c o n . d i ,   0 ) 
 f r o m   t c i r m 0 9 0 6 _ c o n f i g d i v i s i o n y p a r a m   c o n   w i t h   ( n o l o c k ) 
 j o i n   m a v i r e c u p e r a c i o n   m a   w i t h   ( n o l o c k ) 
 o n   i s n u l l ( c o n . d i v i s i o n ,   ' ' )   =   i s n u l l ( m a . d i v i s i o n ,   ' ' ) 
 a n d   m a . q u i n c e n a   =   @ q u i n c e n a 
 a n d   m a . e j e r c i c i o   =   @ y e a r 
 a n d   m a . c l i e n t e   =   @ c l i e n t e 
 s e l e c t 
 @ d v   =   i s n u l l ( @ d v ,   0 ) , 
 @ d i   =   i s n u l l ( @ d i ,   0 ) , 
 @ d v e c   =   i s n u l l ( @ d v e c ,   0 ) , 
 @ d i n a c   =   i s n u l l ( @ d i n a c ,   0 ) 
 s e t   @ c o b   = 
 c a s e 
 w h e n   ( ( @ d v e c   > =   @ d v   a n d 
 @ d v   < >   0 )   o r 
 ( @ d i n a c   > =   @ d i   a n d 
 @ d i   < >   0 ) )   t h e n   ' s i ' 
 e l s e   ' n o ' 
 e n d 
 e n d 
 s e t   @ c o b   =   i s n u l l ( @ c o b ,   ' n o ' ) 
 r e t u r n   @ c o b 
 e n d 