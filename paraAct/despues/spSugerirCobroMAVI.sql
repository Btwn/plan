u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p s u g e r i r c o b r o m a v i ] 
 @ s u g e r i r p a v a r c h a r ( 2 0 ) , 
 @ m o d u l o c h a r ( 5 ) , 
 @ i d i n t , 
 @ i m p o r t e t o t a l m o n e y , 
 @ u s u a r i o v a r c h a r ( 1 0 ) , 
 @ e s t a c i o n i n t 
 a s   b e g i n 
 d e c l a r e 
 @ e m p r e s a c h a r ( 5 ) , 
 @ s u c u r s a l i n t , 
 @ h o y d a t e t i m e , 
 @ v e n c i m i e n t o d a t e t i m e , 
 @ d i a s c r e d i t o i n t , 
 @ d i a s v e n c i d o i n t , 
 @ t a s a d i a r i a f l o a t , 
 @ m o n e d a c h a r ( 1 0 ) , 
 @ t i p o c a m b i o f l o a t , 
 @ c o n t a c t o c h a r ( 1 0 ) , 
 @ r e n g l o n f l o a t , 
 @ a p l i c a v a r c h a r ( 2 0 ) , 
 @ a p l i c a i d v a r c h a r ( 2 0 ) , 
 @ a p l i c a m o v t i p o v a r c h a r ( 2 0 ) , 
 @ c a p i t a l m o n e y , 
 @ i n t e r e s e s m o n e y , 
 @ i n t e r e s e s o r d i n a r i o s m o n e y , 
 @ i n t e r e s e s f i j o s m o n e y , 
 @ i n t e r e s e s m o r a t o r i o s m o n e y , 
 @ i m p u e s t o a d i c i o n a l f l o a t , 
 @ i m p o r t e m o n e y , 
 @ s u m a i m p o r t e m o n e y , 
 @ i m p u e s t o s m o n e y , 
 @ d e s g l o s a r i m p u e s t o s   b i t , 
 @ l i n e a c r e d i t o v a r c h a r ( 2 0 ) , 
 @ m e t o d o i n t , 
 @ g e n e r a m o r a t o r i o m a v i c h a r ( 1 ) , 
 @ m o n t o m i n i m o m o r f l o a t , 
 @ c o n d o n a m o r a t o r i o s i n t , 
 @ i d d e t a l l e i n t , 
 @ i m p r e a l m o n e y , 
 @ m o r a t o r i o a p a g a r m o n e y , 
 @ o r i g e n v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d v a r c h a r ( 2 0 ) , 
 @ m o v p a d r e v a r c h a r ( 2 0 ) , 
 @ m o v p a d r e i d v a r c h a r ( 2 0 ) , 
 @ m o v p a d r e 1 v a r c h a r ( 2 0 ) , 
 @ m o v i d p a d r e v a r c h a r ( 2 0 ) 
 , @ p a d r e m a v i p e n d   v a r c h a r ( 2 0 ) 
 , @ p a d r e m a v i i d p e n d   v a r c h a r ( 2 0 ) 
 , @ n o t a c r e d x c a n c   c h a r ( 1 ) , 
 @ m o v   v a r c h a r ( 2 0 ) , 
 @ a p l i c a n o t a   v a r c h a r ( 2 0 ) , 
 @ a p l i c a i d n o t a   v a r c h a r ( 2 0 ) 
 d e l e t e   n e c i a m o r a t o r i o s m a v i   w h e r e   i d c o b r o   =   @ i d 
 d e l e t e   f r o m   h i s t c o b r o m o r a t o r i o s m a v i   w h e r e   i d c o b r o   =   @ i d 
 i f   e x i s t s ( s e l e c t   *   f r o m   t i p o c o b r o m a v i   w i t h   ( n o l o c k )   w h e r e   i d c o b r o   =   @ i d ) 
 u p d a t e   t i p o c o b r o m a v i   w i t h   ( r o w l o c k )   s e t   t i p o c o b r o   =   0   w h e r e   i d c o b r o   =   @ i d 
 e l s e 
 i n s e r t   i n t o   t i p o c o b r o m a v i ( i d c o b r o ,   t i p o c o b r o )   v a l u e s ( @ i d ,   0 ) 
 c r e a t e   t a b l e   # n o t a x c a n c ( m o v   v a r c h a r ( 2 0 )   n u l l , m o v i d   v a r c h a r ( 2 0 )   n u l l ) 
 i n s e r t   i n t o   # n o t a x c a n c ( m o v , m o v i d ) 
 s e l e c t   d i s t i n c t   d . m o v , d . m o v i d   f r o m   n e c i a m o r a t o r i o s m a v i   c   w i t h   ( n o l o c k ) ,   c x c p e n d i e n t e   d   w i t h   ( n o l o c k ) ,   c x c   n   w i t h   ( n o l o c k )   w h e r e   c . m o v   i n ( ' n o t a   c a r ' , ' n o t a   c a r   v i u ' )   a n d   d . c l i e n t e = @ c o n t a c t o 
 a n d   d . m o v = c . m o v   a n d   d . m o v i d = c . m o v i d   a n d   d . p a d r e m a v i   i n   ( ' c r e d i l a n a ' , ' p r e s t a m o   p e r s o n a l ' )   a n d   n . m o v = c . m o v   a n d   n . m o v i d = c . m o v i d 
 a n d   n . c o n c e p t o   i n   ( ' c a n c   c o b r o   c r e d   y   p p ' ) 
 s e l e c t   @ d e s g l o s a r i m p u e s t o s   =   0   ,   @ r e n g l o n   =   0 . 0 ,   @ s u m a i m p o r t e   =   0 . 0 ,   @ i m p o r t e t o t a l   =   n u l l i f ( @ i m p o r t e t o t a l ,   0 . 0 ) ,   @ s u g e r i r p a   =   u p p e r ( @ s u g e r i r p a ) 
 s e l e c t   @ e m p r e s a   =   e m p r e s a ,   @ s u c u r s a l   =   s u c u r s a l ,   @ h o y   =   f e c h a e m i s i o n ,   @ m o n e d a   =   m o n e d a ,   @ t i p o c a m b i o   =   t i p o c a m b i o ,   @ c o n t a c t o   =   c l i e n t e ,   @ m o v   =   m o v   f r o m   c x c   w i t h   ( n o l o c k )   w h e r e   i d   =   @ i d 
 i f   @ s u g e r i r p a   < >   ' i m p o r t e   e s p e c i f i c o '   s e l e c t   @ i m p o r t e t o t a l   =   9 9 9 9 9 9 9 
 s e l e c t   @ m o n t o m i n i m o m o r   =   i s n u l l ( m o n t o m i n m o r a t o r i o m a v i , 0 . 0 )   f r o m   e m p r e s a c f g 2   w i t h   ( n o l o c k )   w h e r e   e m p r e s a   =   @ e m p r e s a 
 i f   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 s e l e c t   @ e m p r e s a   =   e m p r e s a ,   @ s u c u r s a l   =   s u c u r s a l ,   @ h o y   =   f e c h a e m i s i o n ,   @ m o n e d a   =   m o n e d a ,   @ t i p o c a m b i o   =   t i p o c a m b i o ,   @ c o n t a c t o   =   c l i e n t e   f r o m   c x c   w i t h   ( n o l o c k )   w h e r e   i d   =   @ i d 
 d e l e t e   c x c d   w h e r e   i d   =   @ i d 
 d e c l a r e   c r a p l i c a   c u r s o r   f o r 
 s e l e c t   p . m o v ,   p . m o v i d ,   p . v e n c i m i e n t o ,   m t . c l a v e ,   i s n u l l ( p . s a l d o * m t . f a c t o r * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) ,   i s n u l l ( p . i n t e r e s e s o r d i n a r i o s * m t . f a c t o r * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) ,   i s n u l l ( p . i n t e r e s e s f i j o s * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) , 
 i s n u l l ( p . i n t e r e s e s m o r a t o r i o s * m t . f a c t o r * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) ,   i s n u l l ( p . o r i g e n ,   p . m o v ) ,   i s n u l l ( p . o r i g e n i d ,   p . m o v i d ) 
 , p . p a d r e m a v i ,   p . p a d r e i d m a v i 
 f r o m   c x c p e n d i e n t e   p   w i t h   ( n o l o c k ) 
 j o i n   m o v t i p o   m t   w i t h   ( n o l o c k )   o n   m t . m o d u l o   =   @ m o d u l o   a n d   m t . m o v   =   p . m o v 
 l e f t   o u t e r   j o i n   c f g a p l i c a o r d e n   a   w i t h   ( n o l o c k )   o n   a . m o d u l o   =   @ m o d u l o   a n d   a . m o v   =   p . m o v 
 l e f t   o u t e r   j o i n   c x c   r   w i t h   ( n o l o c k )   o n   r . i d   =   p . r a m a i d 
 l e f t   o u t e r   j o i n   t i p o a m o r t i z a c i o n   t a   w i t h   ( n o l o c k )   o n   t a . t i p o a m o r t i z a c i o n   =   r . t i p o a m o r t i z a c i o n 
 w h e r e   p . e m p r e s a   =   @ e m p r e s a   a n d   p . c l i e n t e   =   @ c o n t a c t o   a n d   m t . c l a v e   n o t   i n   ( ' c x c . s c h ' , ' c x c . s d ' ,   ' c x c . n c ' ) 
 o r d e r   b y   a . o r d e n ,   p . v e n c i m i e n t o ,   p . m o v ,   p . m o v i d 
 s e l e c t   @ d e s g l o s a r i m p u e s t o s   =   i s n u l l ( c x c c o b r o i m p u e s t o s ,   0 )   f r o m   e m p r e s a c f g 2   w i t h   ( n o l o c k )   w h e r e   e m p r e s a   =   @ e m p r e s a 
 e n d   e l s e 
 r e t u r n 
 o p e n   c r a p l i c a 
 f e t c h   n e x t   f r o m   c r a p l i c a   i n t o   @ a p l i c a ,   @ a p l i c a i d ,   @ v e n c i m i e n t o ,   @ a p l i c a m o v t i p o ,   @ c a p i t a l ,   @ i n t e r e s e s o r d i n a r i o s ,   @ i n t e r e s e s f i j o s ,   @ i n t e r e s e s m o r a t o r i o s ,   @ o r i g e n ,   @ o r i g e n i d 
 , @ p a d r e m a v i p e n d ,   @ p a d r e m a v i i d p e n d 
 w h i l e   @ @ f e t c h _ s t a t u s   < >   - 1   a n d   ( ( @ s u g e r i r p a   =   ' s a l d o   v e n c i d o '   a n d   @ v e n c i m i e n t o < = @ h o y   a n d   @ i m p o r t e t o t a l   >   @ s u m a i m p o r t e   )   o r   ( @ s u g e r i r p a   =   ' i m p o r t e   e s p e c i f i c o '   a n d   @ i m p o r t e t o t a l   >   @ s u m a i m p o r t e )   o r   @ s u g e r i r p a   =   ' s a l d o   t o t a l ' ) 
 b e g i n 
 i f   @ @ f e t c h _ s t a t u s   < >   - 2 
 b e g i n 
 s e l e c t   @ c o n d o n a m o r a t o r i o s   =   0 ,   @ g e n e r a m o r a t o r i o m a v i   =   n u l l ,   @ i d d e t a l l e   =   0 ,   @ m o r a t o r i o a p a g a r   =   0 
 s e l e c t   @ i d d e t a l l e   =   i d   f r o m   c x c   w i t h   ( n o l o c k )   w h e r e   m o v   =   @ a p l i c a   a n d   m o v i d   =   @ a p l i c a i d 
 s e l e c t   @ g e n e r a m o r a t o r i o m a v i   =   d b o . f n g e n e r a m o r a t o r i o m a v i ( @ i d d e t a l l e ) 
 i f   @ g e n e r a m o r a t o r i o m a v i   =   ' 1 ' 
 b e g i n 
 s e l e c t   @ i n t e r e s e s m o r a t o r i o s   =   0 
 s e l e c t   @ i n t e r e s e s m o r a t o r i o s   =   d b o . f n i n t e r e s m o r a t o r i o m a v i ( @ i d d e t a l l e ) 
 s e l e c t   @ m o r a t o r i o a p a g a r   =   @ i n t e r e s e s m o r a t o r i o s 
 i f   @ i n t e r e s e s m o r a t o r i o s   < =   @ m o n t o m i n i m o m o r   a n d   @ i n t e r e s e s m o r a t o r i o s   >   0 
 b e g i n 
 i f   e x i s t s ( s e l e c t   *   f r o m   c o n d o n a m o r x s i s t m a v i   w i t h   ( n o l o c k )   w h e r e   i d c o b r o   =   @ i d   a n d   i d m o v   =   @ i d d e t a l l e   a n d   e s t a t u s   =   ' a l t a ' ) 
 u p d a t e   c o n d o n a m o r x s i s t m a v i   w i t h   ( r o w l o c k ) 
 s e t   m o n t o o r i g i n a l   =   @ i n t e r e s e s m o r a t o r i o s , 
 m o n t o c o n d o n a d o   =   @ i n t e r e s e s m o r a t o r i o s 
 w h e r e   i d c o b r o   =   @ i d   a n d   i d m o v   =   @ i d d e t a l l e   a n d   e s t a t u s   =   ' a l t a ' 
 e l s e 
 i n s e r t   i n t o   c o n d o n a m o r x s i s t m a v i ( u s u a r i o ,   f e c h a a u t o r i z a c i o n ,   i d m o v , r e n g l o n m o v , m o v , m o v i d , m o n t o o r i g i n a l ,   m o n t o c o n d o n a d o ,   t i p o c o n d o n a c i o n ,   e s t a t u s ,   i d c o b r o ) 
 v a l u e s ( @ u s u a r i o ,   g e t d a t e ( ) ,   @ i d d e t a l l e , 0 , @ a p l i c a ,   @ a p l i c a i d ,   @ i n t e r e s e s m o r a t o r i o s ,   @ i n t e r e s e s m o r a t o r i o s ,   ' p o r   s i s t e m a ' ,   ' a l t a ' ,   @ i d ) 
 s e l e c t   @ i n t e r e s e s m o r a t o r i o s   =   0 
 e n d 
 i f   @ i n t e r e s e s m o r a t o r i o s   >   0   a n d   @ i n t e r e s e s m o r a t o r i o s   >   @ m o n t o m i n i m o m o r 
 b e g i n 
 i f   @ s u m a i m p o r t e   +   @ i n t e r e s e s m o r a t o r i o s   >   @ i m p o r t e t o t a l   s e l e c t   @ m o r a t o r i o a p a g a r   =   @ i m p o r t e t o t a l   -   @ s u m a i m p o r t e 
 s e l e c t   @ s u m a i m p o r t e   =   @ s u m a i m p o r t e   +   @ m o r a t o r i o a p a g a r 
 i f   @ i n t e r e s e s m o r a t o r i o s   >   0 
 b e g i n 
 i n s e r t   n e c i a m o r a t o r i o s m a v i (   i d c o b r o ,   e s t a c i o n ,   u s u a r i o ,   m o v ,   m o v i d ,   i m p o r t e r e a l ,   i m p o r t e a p a g a r ,   i m p o r t e m o r a t o r i o ,   i m p o r t e a c o n d o n a r ,   m o r a t o r i o a p a g a r ,   o r i g e n ,   o r i g e n i d ) 
 v a l u e s ( @ i d ,   @ e s t a c i o n ,   @ u s u a r i o ,   @ a p l i c a ,   @ a p l i c a i d ,   @ c a p i t a l ,   0 ,   @ i n t e r e s e s m o r a t o r i o s ,   0 ,   @ m o r a t o r i o a p a g a r ,   @ p a d r e m a v i p e n d ,   @ p a d r e m a v i i d p e n d ) 
 i f   @ a p l i c a   i n   ( ' n o t a   c a r ' , ' n o t a   c a r   v i u ' ) 
 b e g i n 
 s e l e c t   @ a p l i c a n o t a =   i s n u l l ( m o v , ' n a ' ) ,   @ a p l i c a i d n o t a   =   i s n u l l ( m o v i d , ' n a ' )   f r o m   # n o t a x c a n c   w h e r e   m o v = @ a p l i c a   a n d   m o v i d = @ a p l i c a i d 
 i f   @ a p l i c a n o t a   < >   ' n a '   a n d   @ a p l i c a i d n o t a   < >   ' n a ' 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k )   s e t   n o t a c r e d i t o x c a n c   =   ' 1 '   w h e r e   i d c o b r o   =   @ i d   a n d   e s t a c i o n   =   @ e s t a c i o n   a n d   m o v   =   @ a p l i c a   a n d   m o v i d   =   @ a p l i c a i d 
 e n d 
 e n d 
 e n d 
 e n d 
 e l s e   s e l e c t   @ i n t e r e s e s m o r a t o r i o s   =   0 
 f e t c h   n e x t   f r o m   c r a p l i c a   i n t o   @ a p l i c a ,   @ a p l i c a i d ,   @ v e n c i m i e n t o ,   @ a p l i c a m o v t i p o ,   @ c a p i t a l ,   @ i n t e r e s e s o r d i n a r i o s ,   @ i n t e r e s e s f i j o s ,   @ i n t e r e s e s m o r a t o r i o s ,   @ o r i g e n ,   @ o r i g e n i d 
 , @ p a d r e m a v i p e n d ,   @ p a d r e m a v i i d p e n d 
 e n d 
 e n d 
 c l o s e   c r a p l i c a 
 d e a l l o c a t e   c r a p l i c a 
 i f   @ m o d u l o   =   ' c x c '   a n d   @ s u m a i m p o r t e   < =   @ i m p o r t e t o t a l 
 b e g i n 
 s e l e c t   @ e m p r e s a   =   e m p r e s a ,   @ s u c u r s a l   =   s u c u r s a l ,   @ h o y   =   f e c h a e m i s i o n ,   @ m o n e d a   =   m o n e d a ,   @ t i p o c a m b i o   =   t i p o c a m b i o ,   @ c o n t a c t o   =   c l i e n t e   f r o m   c x c   w i t h   ( n o l o c k )   w h e r e   i d   =   @ i d 
 d e c l a r e   c r d o c t o   c u r s o r   f o r 
 s e l e c t   p . m o v ,   p . m o v i d ,   p . v e n c i m i e n t o ,   m t . c l a v e ,   r o u n d ( i s n u l l ( p . s a l d o * m t . f a c t o r * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) , 2 ) ,   i s n u l l ( p . i n t e r e s e s o r d i n a r i o s * m t . f a c t o r * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) ,   i s n u l l ( p . i n t e r e s e s f i j o s * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) , 
 i s n u l l ( p . i n t e r e s e s m o r a t o r i o s * m t . f a c t o r * p . m o v t i p o c a m b i o / @ t i p o c a m b i o ,   0 . 0 ) ,   i s n u l l ( p . o r i g e n , p . m o v ) ,   i s n u l l ( p . o r i g e n i d ,   p . m o v i d ) 
 , p . p a d r e m a v i   ,   p . p a d r e i d m a v i 
 f r o m   c x c p e n d i e n t e   p   w i t h   ( n o l o c k ) 
 j o i n   m o v t i p o   m t   w i t h   ( n o l o c k )   o n   m t . m o d u l o   =   @ m o d u l o   a n d   m t . m o v   =   p . m o v 
 l e f t   o u t e r   j o i n   c f g a p l i c a o r d e n   a   w i t h   ( n o l o c k )   o n   a . m o d u l o   =   @ m o d u l o   a n d   a . m o v   =   p . m o v 
 l e f t   o u t e r   j o i n   c x c   r   w i t h   ( n o l o c k )   o n   r . i d   =   p . r a m a i d 
 l e f t   o u t e r   j o i n   t i p o a m o r t i z a c i o n   t a   w i t h   ( n o l o c k )   o n   t a . t i p o a m o r t i z a c i o n   =   r . t i p o a m o r t i z a c i o n 
 w h e r e   p . e m p r e s a   =   @ e m p r e s a   a n d   p . c l i e n t e   =   @ c o n t a c t o   a n d   m t . c l a v e   n o t   i n   ( ' c x c . s c h ' , ' c x c . s d ' ,   ' c x c . n c ' ) 
 o r d e r   b y   a . o r d e n ,   p . v e n c i m i e n t o ,   p . m o v ,   p . m o v i d 
 e n d   e l s e 
 r e t u r n 
 o p e n   c r d o c t o 
 f e t c h   n e x t   f r o m   c r d o c t o   i n t o   @ a p l i c a ,   @ a p l i c a i d ,   @ v e n c i m i e n t o ,   @ a p l i c a m o v t i p o ,   @ c a p i t a l ,   @ i n t e r e s e s o r d i n a r i o s ,   @ i n t e r e s e s f i j o s ,   @ i n t e r e s e s m o r a t o r i o s ,   @ o r i g e n ,   @ o r i g e n i d 
 , @ p a d r e m a v i p e n d ,   @ p a d r e m a v i i d p e n d 
 w h i l e   @ @ f e t c h _ s t a t u s   < >   - 1   a n d   ( ( @ s u g e r i r p a   =   ' s a l d o   v e n c i d o '   a n d   @ v e n c i m i e n t o < = @ h o y   a n d   @ i m p o r t e t o t a l   >   @ s u m a i m p o r t e   )   o r   ( @ s u g e r i r p a   =   ' i m p o r t e   e s p e c i f i c o '   a n d   @ i m p o r t e t o t a l   >   @ s u m a i m p o r t e )   o r   @ s u g e r i r p a   =   ' s a l d o   t o t a l ' ) 
 b e g i n 
 i f   @ @ f e t c h _ s t a t u s   < >   - 2 
 b e g i n 
 s e l e c t   @ i m p r e a l   =   @ c a p i t a l 
 i f   @ s u m a i m p o r t e   +   @ c a p i t a l   >   @ i m p o r t e t o t a l   s e l e c t   @ c a p i t a l   =   @ i m p o r t e t o t a l   -   @ s u m a i m p o r t e 
 i f   @ c a p i t a l   >   0 
 b e g i n 
 s e l e c t   @ s u m a i m p o r t e   =   @ s u m a i m p o r t e   +   @ c a p i t a l 
 i f   e x i s t s ( s e l e c t   *   f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k )   w h e r e   i d c o b r o   =   @ i d   a n d   e s t a c i o n   =   @ e s t a c i o n   a n d   m o v   =   @ a p l i c a   a n d   m o v i d   =   @ a p l i c a i d ) 
 b e g i n 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k ) 
 s e t   i m p o r t e a p a g a r   =   @ c a p i t a l 
 w h e r e   e s t a c i o n   =   @ e s t a c i o n 
 a n d   m o v   =   @ a p l i c a 
 a n d   m o v i d   =   @ a p l i c a i d 
 a n d   i d c o b r o   =   @ i d 
 i f   @ a p l i c a   i n   ( ' n o t a   c a r ' , ' n o t a   c a r   v i u ' ) 
 b e g i n 
 s e l e c t   @ a p l i c a n o t a =   i s n u l l ( m o v , ' n a ' ) ,   @ a p l i c a i d n o t a   =   i s n u l l ( m o v i d , ' n a ' )   f r o m   # n o t a x c a n c   w h e r e   m o v = @ a p l i c a   a n d   m o v i d = @ a p l i c a i d 
 i f   @ a p l i c a n o t a   < >   ' n a '   a n d   @ a p l i c a i d n o t a   < >   ' n a ' 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k )   s e t   n o t a c r e d i t o x c a n c   =   ' 1 '   w h e r e   i d c o b r o   =   @ i d   a n d   e s t a c i o n   =   @ e s t a c i o n   a n d   m o v   =   @ a p l i c a   a n d   m o v i d   =   @ a p l i c a i d 
 e n d 
 e n d 
 e l s e 
 b e g i n 
 i n s e r t   n e c i a m o r a t o r i o s m a v i (   i d c o b r o ,   e s t a c i o n ,   u s u a r i o ,   m o v ,   m o v i d ,   i m p o r t e r e a l ,   i m p o r t e a p a g a r ,   i m p o r t e m o r a t o r i o ,   i m p o r t e a c o n d o n a r ,   o r i g e n ,   o r i g e n i d ) 
 v a l u e s ( @ i d ,   @ e s t a c i o n ,   @ u s u a r i o ,   @ a p l i c a ,   @ a p l i c a i d ,   @ i m p r e a l ,   @ c a p i t a l ,   0 ,   0 ,   @ p a d r e m a v i p e n d ,   @ p a d r e m a v i i d p e n d ) 
 i f   @ a p l i c a   i n   ( ' n o t a   c a r ' , ' n o t a   c a r   v i u ' ) 
 b e g i n 
 s e l e c t   @ a p l i c a n o t a =   i s n u l l ( m o v , ' n a ' ) ,   @ a p l i c a i d n o t a   =   i s n u l l ( m o v i d , ' n a ' )   f r o m   # n o t a x c a n c   w h e r e   m o v = @ a p l i c a   a n d   m o v i d = @ a p l i c a i d 
 i f   @ a p l i c a n o t a   < >   ' n a '   a n d   @ a p l i c a i d n o t a   < >   ' n a ' 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k )   s e t   n o t a c r e d i t o x c a n c   =   ' 1 '   w h e r e   i d c o b r o   =   @ i d   a n d   e s t a c i o n   =   @ e s t a c i o n   a n d   m o v   =   @ a p l i c a   a n d   m o v i d   =   @ a p l i c a i d 
 e n d 
 e n d 
 e n d 
 f e t c h   n e x t   f r o m   c r d o c t o   i n t o   @ a p l i c a ,   @ a p l i c a i d ,   @ v e n c i m i e n t o ,   @ a p l i c a m o v t i p o ,   @ c a p i t a l ,   @ i n t e r e s e s o r d i n a r i o s ,   @ i n t e r e s e s f i j o s ,   @ i n t e r e s e s m o r a t o r i o s ,   @ o r i g e n ,   @ o r i g e n i d 
 , @ p a d r e m a v i p e n d ,   @ p a d r e m a v i i d p e n d 
 e n d 
 e n d 
 c l o s e   c r d o c t o 
 d e a l l o c a t e   c r d o c t o 
 d r o p   t a b l e   # n o t a x c a n c 
 e x e c   s p o r i g e n n c x c a n c m a v i   @ i d 
 e x e c   s p o r i g e n c o b r o s i n s t m a v i   @ i d 
 e x e c   s p t i p o p a b o n i f m a v i   @ s u g e r i r p a ,   @ i d 
 e x e c   s p b o n i f m o n t o @ i d 
 e x e c   s p i m p t o t a l b o n i f m a v i   @ i d 
 r e t u r n 
 e n d 