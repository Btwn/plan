u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p m a v i b u s c a c x c v e n t a t e s t ] 
 @ m o v i d c x c   v a r c h a r ( 2 0 ) , 
 @ m o v c x c   v a r c h a r ( 2 0 ) , 
 @ i d m o v r e s u l   v a r c h a r ( 2 0 )   o u t p u t , 
 @ m o v r e s u l   v a r c h a r ( 2 0 )   o u t p u t , 
 @ i d o r i g e n   i n t   o u t p u t 
 a s   b e g i n 
 d e c l a r e 
 @ t i p o   v a r c h a r ( 2 0 ) , 
 @ i d n v o   v a r c h a r ( 2 0 ) , 
 @ i d m o v n v o   v a r c h a r ( 2 0 ) , 
 @ i d m o v n v o 2   v a r c h a r ( 2 0 ) , 
 @ m o v t i p o n v o   v a r c h a r ( 2 0 ) , 
 @ i d o r i g e n n v o   i n t , 
 @ i d c x c   i n t , 
 @ a p l i c a   v a r c h a r ( 2 0 ) , 
 @ a p l i c a i d   v a r c h a r ( 2 0 ) , 
 @ i d d e t a l l e   v a r c h a r ( 2 0 ) , 
 @ c o n t a d o r   i n t   , 
 @ c o n t a d o r d   i n t , 
 @ c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ c v e a f e c t a   v a r c h a r ( 2 0 ) 
 s e l e c t   @ t i p o   =   ' c x c ' ,   @ i d n v o   =   @ m o v i d c x c ,   @ i d m o v n v o =   @ m o v c x c ,   @ c o n t a d o r   =   0 ,   @ c o n t a d o r d   =   0 ,   @ m o v t i p o n v o   =   ' ' 
 s e l e c t   @ i d c x c   =   i d ,   @ c o n c e p t o   =   c o n c e p t o   f r o m   c x c   w h e r e   m o v   =   @ m o v c x c   a n d   m o v i d   =   @ m o v i d c x c 
 s e l e c t   @ c v e a f e c t a   =   c l a v e   f r o m   m o v t i p o   w h e r e   m o d u l o   =   ' c x c '   a n d   m o v   =   @ m o v c x c 
 i f   @ c v e a f e c t a   =   ' c x c . c a '   a n d   @ c o n c e p t o   =   ' m o n e d e r o   e l e c t r o n i c o ' 
 s e l e c t   @ i d m o v r e s u l = @ m o v i d c x c ,   @ m o v r e s u l = @ m o v c x c ,   @ i d o r i g e n =   @ i d c x c 
 e l s e 
 b e g i n 
 w h i l e   @ m o v t i p o n v o   n o t   i n ( ' v t a s . f ' , ' c x c . e s t ' )   a n d   @ c o n t a d o r   <   1 0 
 b e g i n 
 s e l e c t   @ t i p o = o m o d u l o ,   @ i d m o v n v o = o m o v ,   @ i d n v o = ( o m o v i d ) , @ i d o r i g e n n v o = i s n u l l ( m f . o i d , 0 ) ,   @ m o v t i p o n v o   =   m t . c l a v e 
 f r o m   m o v f l u j o   m f   ,   m o v t i p o   m t   w h e r e   m f . o m o v = m t . m o v 
 a n d   m f . d m o v   =   @ i d m o v n v o   a n d   m f . d m o v i d   =   @ i d n v o   a n d   d m o d u l o   =   ' c x c ' 
 o r d e r   b y   o m o v i d   d e s c 
 i f   @ m o v t i p o n v o   =   ' c x c . e s t ' 
 b e g i n 
 s e l e c t   @ i d o r i g e n n v o   =   o i d , @ i d n v o   =   o m o v i d , @ i d m o v n v o   =   o m o v 
 f r o m   m o v f l u j o   m f   ,   m o v t i p o   m t   w h e r e   m f . o m o v = m t . m o v 
 a n d   m f . d m o v   =   @ m o v c x c   a n d   m f . d m o v i d   =   @ m o v i d c x c   a n d   d m o d u l o   =   ' c x c ' 
 o r d e r   b y   o m o v i d   d e s c 
 e n d 
 s e l e c t   @ c o n t a d o r   =   @ c o n t a d o r   +   1 
 e n d 
 i f   @ c o n t a d o r   >   1 0   s e l e c t   @ i d n v o   =   n u l l ,   @ i d m o v n v o   =   n u l l ,   @ i d o r i g e n n v o   =   0 
 s e l e c t   @ a p l i c a   =   a p l i c a ,   @ a p l i c a i d   =   a p l i c a i d   f r o m   c x c d   w h e r e   i d   =   @ i d o r i g e n 
 i f   n o t   @ a p l i c a i d   i s   n u l l 
 b e g i n 
 d e c l a r e   c r c x c c t e   c u r s o r   f o r 
 s e l e c t   i d   f r o m   c x c   w h e r e   m o v   =   @ a p l i c a   a n d   m o v i d   =   @ a p l i c a i d 
 o p e n   c r c x c c t e 
 f e t c h   n e x t   f r o m   c r c x c c t e   i n t o   @ i d m o v n v o 2 
 w h i l e   @ m o v t i p o n v o   < >   ' v t a s . f '   a n d   @ c o n t a d o r d   <   1 0 
 b e g i n 
 s e l e c t   @ t i p o = o m o d u l o ,   @ i d m o v n v o = o m o v ,   @ i d n v o = ( o m o v i d ) , @ i d o r i g e n n v o = m f . o i d ,   @ m o v t i p o n v o   =   m t . c l a v e 
 f r o m   m o v f l u j o   m f   ,   m o v t i p o   m t   w h e r e   m f . o m o v   =   m t . m o v 
 a n d   m f . d m o v   =   @ i d m o v n v o 2   a n d   m f . d m o v i d   =   @ i d n v o   a n d   d m o d u l o   =   ' c x c ' 
 o r d e r   b y   o m o v i d   d e s c 
 s e l e c t   @ c o n t a d o r d   =   @ c o n t a d o r d   +   1 
 f e t c h   n e x t   f r o m   c r c x c c t e   i n t o   @ i d m o v n v o 2 
 e n d 
 c l o s e   c r c x c c t e 
 d e a l l o c a t e   c r c x c c t e 
 e n d 
 s e l e c t   @ i d m o v r e s u l = @ i d n v o ,   @ m o v r e s u l = @ i d m o v n v o ,   @ i d o r i g e n =   @ i d o r i g e n n v o 
 r e t u r n 
 e n d 
 e n d 