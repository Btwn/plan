u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p b o n i f i c a c i o n e s c a l c u l a t a b l a ]   @ i d c x c   i n t , 
 @ e s t a c i o n   i n t   =   1 , 
 @ t i p o   c h a r ( 1 0 ) , 
 @ i d c o b r o   i n t 
 a s 
 b e g i n 
 d e c l a r e 
 @ e m p r e s a   v a r c h a r ( 5 ) , 
 @ m o v   v a r c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ u e n   i n t , 
 @ t i p o c a m b i o   f l o a t , 
 @ c l i e n t e e n v i a r a   i n t , 
 @ c o n d i c i o n   v a r c h a r ( 5 0 ) , 
 @ v e n c i m i e n t o   d a t e t i m e , 
 @ i m p o r t e v e n t a   f l o a t , 
 @ i m p o r t e d o c t o   f l o a t , 
 @ i m p o r t e c a s c a   f l o a t , 
 @ i m p u e s t o s   f l o a t , 
 @ s a l d o   f l o a t , 
 @ r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ d o c u m e n t o 1 d e   i n t , 
 @ d o c u m e n t o t o t a l   i n t , 
 @ o r i g e n t i p o   v a r c h a r ( 2 0 ) , 
 @ o r i g e n   v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d   v a r c h a r ( 2 0 ) , 
 @ s u c u r s a l   i n t , 
 @ t i p o s u c u r s a l   v a r c h a r ( 5 0 ) , 
 @ e x t r a e d   i n t , 
 @ e x t r a e a   i n t , 
 @ i d v e n t a   i n t , 
 @ m o v i d v e n t a   v a r c h a r ( 2 0 ) , 
 @ m o v v e n t a   v a r c h a r ( 2 0 ) , 
 @ l i n e a v t a   v a r c h a r ( 5 0 ) , 
 @ m a x d i a s a t r a z o   f l o a t , 
 @ d i a s m e n o r e s a   i n t , 
 @ d i a s m a y o r e s a   i n t , 
 @ i d   i n t , 
 @ b o n i f i c a c i o n   v a r c h a r ( 5 0 ) , 
 @ e s t a t u s   v a r c h a r ( 1 5 ) , 
 @ p o r c b o n 1   f l o a t , 
 @ m o n t o b o n i f   f l o a t , 
 @ f i n a n c i a m i e n t o   f l o a t , 
 @ f e c h a i n i   d a t e t i m e , 
 @ f e c h a f i n   d a t e t i m e , 
 @ p a t o t a l   b i t , 
 @ a c t v i g e n c i a   b i t , 
 @ c a s c a d a c a l c   b i t , 
 @ a p l i c a a   c h a r ( 3 0 ) , 
 @ p l a z o e j e f i n   i n t , 
 @ v a l b o n i f   f l o a t , 
 @ v e n c i m i e n t o a n t e s   i n t , 
 @ v e n c i m i e n t o d e s p   i n t , 
 @ d i a s a t r a z o   i n t , 
 @ f a c t o r   f l o a t , 
 @ m e s e s e x c e d   i n t , 
 @ l i n e a   f l o a t , 
 @ f e c h a c a n c e l a c i o n   d a t e t i m e , 
 @ f e c h a r e g i s t r o   d a t e t i m e , 
 @ u s u a r i o   v a r c h a r ( 1 0 ) , 
 @ o k   i n t , 
 @ o k r e f   v a r c h a r ( 5 0 ) , 
 @ p e r i o d o   i n t , 
 @ c h a r r e f e r e n c i a   v a r c h a r ( 2 0 ) , 
 @ e j e r c i c i o   i n t , 
 @ b o n i f i c h i j o   v a r c h a r ( 5 0 ) , 
 @ b o n i f i c h i j o c a s c a d   v a r c h a r ( 5 ) , 
 @ r e f i n a n   v a r c h a r ( 5 ) , 
 @ l i n e a c e l u l a r e s   f l o a t , 
 @ d i a s v e n c i m i e n t o   i n t , 
 @ l i n e a c r e d i l a n a s   f l o a t , 
 @ b a s e p a r a a p l i c a r   f l o a t 
 , @ p a d r e m a v i   v a r c h a r ( 2 0 ) 
 , @ p a d r e m a v i i d   v a r c h a r ( 2 0 ) , 
 @ e s o r i g e n n u l o   i n t 
 , @ l i n e a m o t o s   f l o a t 
 , @ l i n e a b o n i f   v a r c h a r ( 2 5 ) 
 ,   @ f e c h a e m i s i o n f a c t   d a t e t i m e 
 s e l e c t   @ o k r e f   =   ' ' ,   @ e j e r c i c i o   =   y e a r ( g e t d a t e ( ) ) ,   @ p e r i o d o   =   m o n t h ( g e t d a t e ( ) ) ,   @ m a x d i a s a t r a z o   =   0 . 0 0 ,   @ m o v   =   ' ' , @ d i a s m e n o r e s a = 0 ,   @ d i a s m a y o r e s a = 0 
 s e l e c t   @ c h a r r e f e r e n c i a =   0   ,   @ i m p o r t e v e n t a   =   0 . 0 0 ,   @ i m p o r t e d o c t o   =   0 . 0 0 ,   @ m e s e s e x c e d = 0 ,   @ i m p o r t e c a s c a   =   0 . 0 0 ,   @ b a s e p a r a a p l i c a r   =   0 . 0 0 , @ e s o r i g e n n u l o = 0 
 i f   @ i d c o b r o   =   n u l l   s e l e c t   @ i d c o b r o =   0 
 s e l e c t   @ e m p r e s a = c . e m p r e s a , @ m o v = c . m o v , @ m o v i d = c . m o v i d ,   @ f e c h a e m i s i o n = c . f e c h a e m i s i o n , @ c o n c e p t o = c . c o n c e p t o , @ u e n = c . u e n ,   @ f e c h a e m i s i o n f a c t   =   c . f e c h a e m i s i o n   , 
 @ t i p o c a m b i o = c . t i p o c a m b i o , @ c l i e n t e e n v i a r a = c . c l i e n t e e n v i a r a , @ c o n d i c i o n = c . c o n d i c i o n , @ v e n c i m i e n t o = c . v e n c i m i e n t o , @ i m p o r t e d o c t o = c . i m p o r t e + c . i m p u e s t o s , 
 @ i m p u e s t o s = c . i m p u e s t o s , @ s a l d o = c . s a l d o , @ v e n c i m i e n t o = c . v e n c i m i e n t o , @ c o n c e p t o = c . c o n c e p t o , @ r e f e r e n c i a = i s n u l l ( c . r e f e r e n c i a m a v i , c . r e f e r e n c i a ) , 
 @ o r i g e n t i p o = c . o r i g e n t i p o , @ o r i g e n = c . o r i g e n ,   @ o r i g e n i d = c . o r i g e n i d , @ s u c u r s a l = c . s u c u r s a l o r i g e n , @ m a x d i a s a t r a z o = i s n u l l ( c m . m a x d i a s v e n c i d o s m a v i , 0 . 0 0 ) 
 , @ p a d r e m a v i   =   c . p a d r e m a v i ,   @ p a d r e m a v i i d   =   c . p a d r e i d m a v i 
 f r o m   c x c   c   l e f t   j o i n   c x c m a v i   c m   o n   c m . i d = c . i d 
 w h e r e   c . i d   =   @ i d c x c 
 i f   @ o r i g e n   i s   n u l l 
 b e g i n 
 s e l e c t   @ e m p r e s a = c . e m p r e s a , @ m o v = c . m o v , @ m o v i d = c . m o v i d ,   @ f e c h a e m i s i o n = c . f e c h a e m i s i o n , @ c o n c e p t o = c . c o n c e p t o , @ u e n = c . u e n , 
 @ t i p o c a m b i o = c . t i p o c a m b i o , @ c l i e n t e e n v i a r a = c . c l i e n t e e n v i a r a , @ c o n d i c i o n = c . c o n d i c i o n , @ v e n c i m i e n t o = c . v e n c i m i e n t o , @ i m p o r t e d o c t o = c . i m p o r t e + c . i m p u e s t o s , 
 @ i m p u e s t o s = c . i m p u e s t o s , @ s a l d o = c . s a l d o , @ v e n c i m i e n t o = c . v e n c i m i e n t o , @ c o n c e p t o = c . c o n c e p t o , @ r e f e r e n c i a = i s n u l l ( c . r e f e r e n c i a m a v i , c . r e f e r e n c i a ) , 
 @ o r i g e n t i p o = c . o r i g e n t i p o , @ o r i g e n = c . o r i g e n ,   @ o r i g e n i d = c . o r i g e n i d , @ s u c u r s a l = c . s u c u r s a l o r i g e n , @ m a x d i a s a t r a z o = i s n u l l ( c m . m a x d i a s v e n c i d o s m a v i , 0 . 0 0 ) 
 f r o m   c x c   c   l e f t   j o i n   c x c m a v i   c m   o n   c m . i d = c . i d 
 w h e r e   c . m o v   =   @ m o v   a n d   c . m o v i d   =   @ m o v i d 
 s e l e c t   @ o r i g e n   =   @ m o v   ,   @ o r i g e n i d   =   @ m o v i d 
 s e l e c t   @ e s o r i g e n n u l o = 1 
 s e l e c t   t o p ( 1 ) @ l i n e a v t a   =   l i n e a ,   @ i m p o r t e v e n t a   =   p r e c i o t o t a l ,   @ s u c u r s a l   =   s u c u r s a l v e n t a 
 f r o m   b o n i f s i m a v i   w h e r e   i d c x c   =   @ i d c x c 
 e n d 
 d e l e t e   m a v i b o n i f i c a c i o n t e s t   w h e r e   o r i g e n =   @ p a d r e m a v i   a n d   o r i g e n i d   =   @ p a d r e m a v i i d 
 i f   @ r e f e r e n c i a   i s   n u l l   o r   r t r i m ( @ r e f e r e n c i a ) =   ' '   o r   n o t   @ r e f e r e n c i a   l i k e   ' % / % ' 
 b e g i n 
 s e l e c t   t o p   ( 1 )   @ r e f e r e n c i a = r e f e r e n c i a   f r o m   c x c   w h e r e   p a d r e m a v i   =   @ m o v   a n d   p a d r e i d m a v i   =   @ m o v i d   a n d   m o v   =   ' d o c u m e n t o '   o r d e r   b y   m o v i d 
 e n d 
 i f   p a t i n d e x ( ' % / % ' , @ r e f e r e n c i a )   >   0 
 b e g i n 
 s e l e c t   @ e x t r a e d   =   p a t i n d e x ( ' % ( % ' , @ r e f e r e n c i a ) ,   @ e x t r a e a   =   p a t i n d e x ( ' % / % ' , @ r e f e r e n c i a ) 
 s e l e c t   @ d o c u m e n t o 1 d e   =   s u b s t r i n g ( @ r e f e r e n c i a , @ e x t r a e d + 1 , @ e x t r a e a   -   @ e x t r a e d   - 1 ) 
 s e l e c t   @ e x t r a e d   =   p a t i n d e x ( ' % / % ' , @ r e f e r e n c i a ) ,   @ e x t r a e a   =   p a t i n d e x ( ' % ) % ' , @ r e f e r e n c i a ) 
 s e l e c t   @ d o c u m e n t o t o t a l   =   s u b s t r i n g ( @ r e f e r e n c i a , @ e x t r a e d + 1 , @ e x t r a e a   -   @ e x t r a e d   - 1 ) 
 e n d 
 e x e c   s p m a v i b u s c a c x c v e n t a b o n i f   @ m o v i d , @ m o v ,   @ m o v i d v e n t a   o u t p u t   ,   @ m o v v e n t a   o u t p u t ,   @ i d v e n t a   o u t p u t 
 i f   @ i m p o r t e v e n t a   i s   n u l l 
 s e l e c t   t o p ( 1 ) @ l i n e a v t a   =   l i n e a ,   @ i m p o r t e v e n t a   =   p r e c i o t o t a l ,   @ s u c u r s a l   =   s u c u r s a l v e n t a 
 f r o m   b o n i f s i m a v i   w h e r e   i d c x c   =   @ i d v e n t a 
 i f   @ m o v   l i k e   ' % r e f i n a n % '   s e l e c t   @ r e f i n a n = ' o k ' , @ i m p o r t e v e n t a   =   i m p o r t e + i m p u e s t o s   f r o m   c x c   w h e r e   m o v = @ m o v   a n d   m o v i d = @ m o v i d 
 i f   @ r e f i n a n   i s   n u l l   o r   @ l i n e a v t a   i s   n u l l 
 b e g i n 
 s e l e c t   @ l i n e a v t a   =   i s n u l l ( a . l i n e a , ' ' )   f r o m   v e n t a   , v e n t a d   l e f t   o u t e r   j o i n   a r t   a   o n   a . a r t i c u l o   =   v e n t a d . a r t i c u l o 
 w h e r e   v e n t a . i d   =   v e n t a d . i d 
 a n d   v e n t a . i d   =   @ i d v e n t a 
 i f   @ i m p o r t e v e n t a   i s   n u l l   o r   @ i m p o r t e v e n t a   = 0 
 s e l e c t   @ i m p o r t e v e n t a   =   p r e c i o t o t a l   f r o m   v e n t a   w h e r e   i d   =   @ i d v e n t a 
 e n d   e l s e 
 b e g i n 
 s e l e c t   @ s u c u r s a l = 3 9 ,   @ l i n e a v t a   =   ' ' 
 s e l e c t   @ i m p o r t e v e n t a   =   i m p o r t e   f r o m   c x c   w h e r e   i d   =   @ i d v e n t a 
 e n d 
 s e l e c t   @ t i p o s u c u r s a l = s u c u r s a l t i p o . t i p o   f r o m   s u c u r s a l   ,   s u c u r s a l t i p o   w h e r e   s u c u r s a l . t i p o   =   s u c u r s a l t i p o . t i p o 
 a n d   s u c u r s a l . s u c u r s a l = @ s u c u r s a l 
 i f   e x i s t s   (   s e l e c t 
 s o l c . f e c h a e m i s i o n 
 f r o m   v e n t a   f a c   i n n e r   j o i n   v e n t a   p e d   o n   f a c . o r i g e n   =   p e d . m o v   a n d   f a c . o r i g e n i d   =   p e d . m o v i d 
 i n n e r   j o i n   v e n t a   a n a c   o n   p e d . o r i g e n   =   a n a c . m o v   a n d   p e d . o r i g e n i d   =   a n a c . m o v i d 
 i n n e r   j o i n   v e n t a   s o l c   o n   a n a c . o r i g e n   =   s o l c . m o v   a n d   a n a c . o r i g e n i d   =   s o l c . m o v i d 
 w h e r e   f a c . m o v   =   @ m o v   a n d   f a c . m o v i d   =   @ m o v i d ) 
 b e g i n 
 s e l e c t 
 @ f e c h a e m i s i o n   =   s o l c . f e c h a e m i s i o n 
 f r o m   v e n t a   f a c   i n n e r   j o i n   v e n t a   p e d   o n   f a c . o r i g e n   =   p e d . m o v   a n d   f a c . o r i g e n i d   =   p e d . m o v i d 
 i n n e r   j o i n   v e n t a   a n a c   o n   p e d . o r i g e n   =   a n a c . m o v   a n d   p e d . o r i g e n i d   =   a n a c . m o v i d 
 i n n e r   j o i n   v e n t a   s o l c   o n   a n a c . o r i g e n   =   s o l c . m o v   a n d   a n a c . o r i g e n i d   =   s o l c . m o v i d 
 w h e r e   f a c . m o v   =   @ m o v   a n d   f a c . m o v i d   =   @ m o v i d 
 e n d 
 s e l e c t 
 @ i m p o r t e v e n t a   =   ( ( ( d o c . i m p o r t e + d o c . i m p u e s t o s ) ) - i s n u l l ( m o n . a b o n o , 0 ) ) 
 f r o m   d b o . c x c   d o c   l e f t   j o i n   d b o . c o n d i c i o n   c o n   o n   c o n . c o n d i c i o n = d o c . c o n d i c i o n 
 l e f t   j o i n   d b o . a u x i l i a r p   m o n   o n   m o n . m o v = d o c . m o v   a n d   m o n . m o v i d = d o c . m o v i d   a n d   i s n u l l ( m o n . a b o n o , 0 ) > 0 
 w h e r e   d o c . m o v = @ m o v   a n d   d o c . m o v i d = @ m o v i d 
 i f   e x i s t s ( s e l e c t   *   f r o m   t e m p d b . s y s . s y s o b j e c t s   w h e r e   i d = o b j e c t _ i d ( ' t e m p d b . d b o . # c r b o n i f a p l i c a r ' )   a n d   t y p e   = ' u ' ) 
 d r o p   t a b l e   # c r b o n i f a p l i c a r 
 c r e a t e   t a b l e   # c r b o n i f a p l i c a r   ( r e g   i n t   i d e n t i t y ,   i d   i n t ,   b o n i f i c a c i o n   v a r c h a r ( 1 0 0 ) , p o r c b o n 1   f l o a t   n u l l ,   f i n a n c i a m i e n t o   f l o a t   n u l l ,   f e c h a i n i   d a t e t i m e , f e c h a f i n   d a t e t i m e ,   p a t o t a l   b i t   ,   a c t v i g e n c i a   b i t 
 , a p l i c a a   v a r c h a r ( 3 0 )   n u l l   ,   p l a z o e j e f i n   i n t , v e n c i m i e n t o a n t e s   i n t   n u l l , v e n c i m i e n t o d e s p   i n t   n u l l   , d i a s a t r a z o   i n t   n u l l , d i a s m e n o r e s a   i n t   n u l l ,   d i a s m a y o r e s a   i n t   n u l l   , 
 f a c t o r   f l o a t   n u l l   , l i n e a   f l o a t   n u l l   ,   f e c h a c a n c e l a c i o n   d a t e t i m e   n u l l , f e c h a r e g i s t r o   d a t e t i m e   n u l l   , u s u a r i o   v a r c h a r ( 1 0 )   n u l l   , l i n e a b o n i f   v a r c h a r ( 5 0 )   n u l l ) 
 i f   @ t i p o   =   ' t o t a l ' 
 b e g i n 
 i n s e r t   i n t o   # c r b o n i f a p l i c a r   ( i d   ,   b o n i f i c a c i o n   , p o r c b o n 1   ,   f i n a n c i a m i e n t o   ,   f e c h a i n i   , f e c h a f i n   ,   p a t o t a l   ,   a c t v i g e n c i a   , a p l i c a a   ,   p l a z o e j e f i n   , v e n c i m i e n t o a n t e s 
 , v e n c i m i e n t o d e s p   , d i a s a t r a z o   , d i a s m e n o r e s a   ,   d i a s m a y o r e s a   ,   f a c t o r   , l i n e a   ,   f e c h a c a n c e l a c i o n   , f e c h a r e g i s t r o   , u s u a r i o   , l i n e a b o n i f   ) 
 s e l e c t   m b c . i d ,   m b c . b o n i f i c a c i o n , m b c . p o r c b o n 1 , m b c . f i n a n c i a m i e n t o ,   m b c . f e c h a i n i , m b c . f e c h a f i n , m b c . p a t o t a l , m b c . a c t v i g e n c i a 
 , m b c . a p l i c a a , m b c . p l a z o e j e f i n , v e n c i m i e n t o a n t e s = i s n u l l ( m b c . v e n c i m i e n t o a n t e s , 0 ) , v e n c i m i e n t o d e s p = i s n u l l ( m b c . v e n c i m i e n t o d e s p , 0 ) 
 , d i a s a t r a z o = i s n u l l ( m b c . d i a s a t r a z o , 0 ) , d i a s m e n o r e s a = i s n u l l ( m b c . d i a s m e n o r e s a , 0 ) , d i a s m a y o r e s a = i s n u l l ( m b c . d i a s m a y o r e s a , 0 ) , 
 m b c . f a c t o r , l i n e a = i s n u l l ( m b c . l i n e a , 0 . 0 0 ) , m b c . f e c h a c a n c e l a c i o n , m b c . f e c h a r e g i s t r o , m b c . u s u a r i o , m b l . l i n e a 
 f r o m   m a v i b o n i f i c a c i o n c o n f   m b c   i n n e r   j o i n   m a v i b o n i f i c a c i o n m o v   m b m v   o n   m b c . i d   =   m b m v . i d b o n i f i c a c i o n 
 i n n e r   j o i n   d b o . m a v i b o n i f i c a c i o n c o n d i c i o n   m b c 2   o n   m b c 2 . i d b o n i f i c a c i o n = m b c . i d 
 l e f t   j o i n   d b o . m a v i b o n i f i c a c i o n l i n e a   m b l   o n   m b l . i d b o n i f i c a c i o n = m b c . i d 
 w h e r e   m b m v . m o v i m i e n t o   =   @ m o v 
 a n d   c o n d i c i o n   =   @ c o n d i c i o n 
 a n d   m b c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ f e c h a e m i s i o n   b e t w e e n   m b c . f e c h a i n i   a n d   m b c . f e c h a f i n 
 a n d   m b c . n o p u e d e a p l i c a r s o l a   =   0 
 o r d e r   b y   m b c . o r d e n   d e s c 
 e n d 
 e l s e 
 b e g i n 
 i n s e r t   i n t o   # c r b o n i f a p l i c a r   ( i d   ,   b o n i f i c a c i o n   , p o r c b o n 1   ,   f i n a n c i a m i e n t o   ,   f e c h a i n i   , f e c h a f i n   ,   p a t o t a l   ,   a c t v i g e n c i a   , a p l i c a a   ,   p l a z o e j e f i n   , v e n c i m i e n t o a n t e s 
 , v e n c i m i e n t o d e s p   , d i a s a t r a z o   , d i a s m e n o r e s a   ,   d i a s m a y o r e s a   ,   f a c t o r   , l i n e a   ,   f e c h a c a n c e l a c i o n   , f e c h a r e g i s t r o   , u s u a r i o   , l i n e a b o n i f   ) 
 s e l e c t   m b c . i d ,   m b c . b o n i f i c a c i o n , m b c . p o r c b o n 1 , m b c . f i n a n c i a m i e n t o ,   m b c . f e c h a i n i , m b c . f e c h a f i n , m b c . p a t o t a l , m b c . a c t v i g e n c i a , m b c . a p l i c a a , m b c . p l a z o e j e f i n , 
 i s n u l l ( m b c . v e n c i m i e n t o a n t e s , 0 ) ,   i s n u l l ( m b c . v e n c i m i e n t o d e s p , 0 ) , 
 i s n u l l ( m b c . d i a s a t r a z o , 0 ) , i s n u l l ( m b c . d i a s m e n o r e s a , 0 ) , i s n u l l ( m b c . d i a s m a y o r e s a , 0 ) , 
 m b c . f a c t o r , i s n u l l ( m b c . l i n e a , 0 . 0 0 ) , m b c . f e c h a c a n c e l a c i o n , m b c . f e c h a r e g i s t r o , m b c . u s u a r i o , n u l l 
 f r o m   m a v i b o n i f i c a c i o n c o n f   m b c   i n n e r   j o i n   m a v i b o n i f i c a c i o n m o v   m b m v   o n   m b c . i d   =   m b m v . i d b o n i f i c a c i o n 
 i n n e r   j o i n   d b o . m a v i b o n i f i c a c i o n c o n d i c i o n   m b c 2   o n   m b c 2 . i d b o n i f i c a c i o n = m b c . i d 
 w h e r e   m b m v . m o v i m i e n t o   =   @ m o v 
 a n d   c o n d i c i o n   =   @ c o n d i c i o n 
 a n d   m b c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ f e c h a e m i s i o n   b e t w e e n   m b c . f e c h a i n i   a n d   m b c . f e c h a f i n 
 a n d   m b c . n o p u e d e a p l i c a r s o l a   =   0 
 a n d   n o t   m b c . b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 o r d e r   b y   m b c . o r d e n   d e s c 
 e n d 
 d e c l a r e   @ t o t b o n i f s   i n t ,   @ r e c o r r e   i n t   ,   @ t i n c l u y e   i n t , @ a v a n z a   i n t 
 s e l e c t   @ t o t b o n i f s   =   m a x ( r e g )   ,   @ r e c o r r e   =   1 
 f r o m   # c r b o n i f a p l i c a r 
 w h i l e   @ r e c o r r e   < =   @ t o t b o n i f s 
 b e g i n 
 s e l e c t   @ o k   =   n u l l ,   @ o k r e f   =   n u l l   , 
 @ i d = i d ,   @ b o n i f i c a c i o n   =   b o n i f i c a c i o n   , @ p o r c b o n 1   =   p o r c b o n 1   , @ f i n a n c i a m i e n t o   =   f i n a n c i a m i e n t o   , @ f e c h a i n i   =   f e c h a i n i   , @ f e c h a f i n   =   f e c h a f i n , @ p a t o t a l   =   p a t o t a l 
 , @ a c t v i g e n c i a   =   a c t v i g e n c i a   , @ a p l i c a a   =   a p l i c a a , @ p l a z o e j e f i n   =   p l a z o e j e f i n ,   @ v e n c i m i e n t o a n t e s   =   v e n c i m i e n t o a n t e s ,   @ v e n c i m i e n t o d e s p   =   v e n c i m i e n t o d e s p , 
 @ d i a s a t r a z o   =   d i a s a t r a z o ,   @ d i a s m e n o r e s a   =   d i a s m e n o r e s a ,   @ d i a s m a y o r e s a   =   d i a s m a y o r e s a ,   @ f a c t o r   =   f a c t o r   , @ l i n e a   =   l i n e a , @ f e c h a c a n c e l a c i o n   =   f e c h a c a n c e l a c i o n 
 , @ f e c h a r e g i s t r o   =   f e c h a r e g i s t r o   , @ u s u a r i o   =   u s u a r i o   , @ l i n e a b o n i f   =   l i n e a b o n i f 
 f r o m   # c r b o n i f a p l i c a r 
 w h e r e   r e g   =   @ r e c o r r e 
 d e c l a r e   @ l i n e a v e n t a b o n i f   v a r c h a r ( 5 0 ) 
 s e l e c t   t o p   1   @ l i n e a v e n t a b o n i f   =   i s n u l l ( l i n e a , @ l i n e a v t a ) 
 f r o m   b o n i f s i m a v i   w h e r e   i d c x c   =   @ i d v e n t a   a n d   l i n e a   i n   ( s e l e c t   m b l . l i n e a 
 f r o m   m a v i b o n i f i c a c i o n c o n f   m b c   i n n e r   j o i n   m a v i b o n i f i c a c i o n m o v   m b m v   o n   m b c . i d   =   m b m v . i d b o n i f i c a c i o n 
 i n n e r   j o i n   m a v i b o n i f i c a c i o n c o n d i c i o n   m b c 2   o n   m b c 2 . i d b o n i f i c a c i o n = m b c . i d 
 l e f t   j o i n   m a v i b o n i f i c a c i o n l i n e a   m b l   o n   i d = m b l . i d b o n i f i c a c i o n 
 w h e r e   m b m v . m o v i m i e n t o   =   @ m o v 
 a n d   c o n d i c i o n   =   @ c o n d i c i o n 
 a n d   m b c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ f e c h a e m i s i o n   b e t w e e n   m b c . f e c h a i n i   a n d   m b c . f e c h a f i n 
 a n d   m b c . n o p u e d e a p l i c a r s o l a   =   0 
 a n d   b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 ) 
 s e l e c t   @ l i n e a v e n t a b o n i f   =   i s n u l l ( a . l i n e a , @ l i n e a v t a )   f r o m   v e n t a   , v e n t a d   l e f t   o u t e r   j o i n   a r t   a   o n   a . a r t i c u l o   =   v e n t a d . a r t i c u l o 
 w h e r e   v e n t a . i d   =   v e n t a d . i d 
 a n d   v e n t a . i d   =   @ i d v e n t a 
 a n d   a . l i n e a   i n   ( s e l e c t   m b l . l i n e a 
 f r o m   m a v i b o n i f i c a c i o n c o n f   m b c   i n n e r   j o i n   m a v i b o n i f i c a c i o n m o v   m b m v   o n   m b c . i d   =   m b m v . i d b o n i f i c a c i o n 
 i n n e r   j o i n   m a v i b o n i f i c a c i o n c o n d i c i o n   m b c 2   o n   m b c 2 . i d b o n i f i c a c i o n = m b c . i d 
 l e f t   j o i n   m a v i b o n i f i c a c i o n l i n e a   m b l   o n   i d = m b l . i d b o n i f i c a c i o n 
 w h e r e   m b m v . m o v i m i e n t o   =   @ m o v 
 a n d   c o n d i c i o n   =   @ c o n d i c i o n 
 a n d   m b c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ f e c h a e m i s i o n   b e t w e e n   m b c . f e c h a i n i   a n d   m b c . f e c h a f i n 
 a n d   m b c . n o p u e d e a p l i c a r s o l a   =   0 
 a n d   b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' ) 
 s e l e c t   @ l i n e a v e n t a b o n i f   =   i s n u l l ( @ l i n e a v e n t a b o n i f , @ l i n e a v t a ) 
 s e l e c t   @ l i n e a v t a = @ l i n e a v e n t a b o n i f 
 i f   @ l i n e a v e n t a b o n i f   i n   ( s e l e c t   m b l . l i n e a 
 f r o m   m a v i b o n i f i c a c i o n c o n f   m b c   i n n e r   j o i n   m a v i b o n i f i c a c i o n m o v   m b m v   o n   m b c . i d   =   m b m v . i d b o n i f i c a c i o n 
 i n n e r   j o i n   m a v i b o n i f i c a c i o n c o n d i c i o n   m b c 2   o n   m b c 2 . i d b o n i f i c a c i o n = m b c . i d 
 l e f t   j o i n   m a v i b o n i f i c a c i o n l i n e a   m b l   o n   i d = m b l . i d b o n i f i c a c i o n 
 w h e r e   m b m v . m o v i m i e n t o   =   @ m o v 
 a n d   c o n d i c i o n   =   @ c o n d i c i o n 
 a n d   m b c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ f e c h a e m i s i o n   b e t w e e n   m b c . f e c h a i n i   a n d   m b c . f e c h a f i n 
 a n d   m b c . n o p u e d e a p l i c a r s o l a   =   0 
 a n d   b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' )   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i f   i s n u l l ( @ l i n e a b o n i f , ' ' ) < > ' '   a n d   i s n u l l ( @ l i n e a v e n t a b o n i f , ' ' ) < > ' '   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i f   @ l i n e a b o n i f   =   @ l i n e a v e n t a b o n i f 
 s e l e c t   @ o k   =   n u l l ,   @ o k r e f   =   n u l l 
 e n d 
 e l s e   s e l e c t   @ o k   =   1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   p a r a m e t r o   l i n e a   p a r a   e s t a   b o n i f i c a c i o n ' 
 e n d 
 e l s e   i f   i s n u l l ( @ l i n e a b o n i f , ' ' ) = ' '   a n d   i s n u l l ( @ l i n e a v e n t a b o n i f , ' ' ) < > ' '   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i f   e x i s t s ( s e l e c t   b o n i f i c a c i o n   f r o m   d b o . m a v i b o n i f i c a c i o n t e s t   w h e r e   b o n i f i c a c i o n = @ b o n i f i c a c i o n   a n d   o k = 0   a n d   i d c o b r o = @ i d c o b r o ) 
 s e l e c t   @ o k   =   1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   p a r a m e t r o   d e   l a   l i n e a   p a r a   e s t a   b o n i f i c a c i o n ' 
 e l s e 
 s e l e c t   @ o k   =   n u l l ,   @ o k r e f   =   n u l l 
 e n d 
 e l s e   i f   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 s e l e c t   @ o k   =   1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   p a r a m e t r o   d e   l a   l i n e a   p a r a   e s t a   b o n i f i c a c i o n ' 
 s e l e c t   @ l i n e a b o n i f = ' ' 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   @ l i n e a v t a < > @ l i n e a b o n i f   a n d   @ t i p o   =   ' t o t a l ' 
 a n d   e x i s t s   ( s e l e c t   *   f r o m   m a v i b o n i f i c a c i o n t e s t   w h e r e   i d c o b r o = @ i d c o b r o   a n d   o k = 0   a n d   b o n i f i c a c i o n = @ b o n i f i c a c i o n ) 
 s e l e c t   @ o k   =   1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   p a r a m e t r o   d e   l a   l i n e a   p a r a   e s t a   b o n i f i c a c i o n ' 
 i f   @ t i p o   =   ' t o t a l '   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % a d e l a n t o % ' 
 a n d   e x i s t s   ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n e x c l u y e   w h e r e   b o n i f i c a c i o n n o = @ b o n i f i c a c i o n 
 a n d   i d b o n i f i c a c i o n   i n   ( 
 s e l e c t   i d   f r o m   ( 
 s e l e c t   m b c . i d 
 , o k = c a s e   w h e n   @ e s o r i g e n n u l o   =   0 
 t h e n 
 c a s e   w h e n   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   > =   d b o . f n f e c h a s i n h o r a ( ( s e l e c t   c . v e n c i m i e n t o + 1   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d   a n d   c . r e f e r e n c i a   l i k e   ' % '   +   ' ( '   +   r t r i m ( m b c . v e n c i m i e n t o a n t e s )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l )   +   ' % ' ) ) 
 t h e n   1   e l s e   0   e n d 
 e l s e 
 c a s e   w h e n   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   >   d b o . f n f e c h a s i n h o r a ( i s n u l l ( ( s e l e c t   c . v e n c i m i e n t o   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d 
 a n d   c . r e f e r e n c i a   l i k e   ' % '   +   ' ( '   +   r t r i m ( m b c . v e n c i m i e n t o a n t e s )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l )   +   ' % ' ) , 
 ( c a s e   w h e n   m b c . v e n c i m i e n t o a n t e s = 1   t h e n   @ v e n c i m i e n t o 
 w h e n   m b c . v e n c i m i e n t o a n t e s > 1   t h e n   d a t e a d d ( m m ,   ( m b c . v e n c i m i e n t o a n t e s   -   @ d o c u m e n t o 1 d e ) ,   ( s e l e c t   v e n c i m i e n t o   f r o m   c x c   w h e r e   o r i g e n = @ o r i g e n   a n d   o r i g e n i d = @ o r i g e n i d   a n d   r e f e r e n c i a = @ r e f e r e n c i a )   )   e n d   )   )   ) 
 t h e n   1   e l s e   0   e n d 
 e n d , 
 d i a s a t r a z o = c a s e   w h e n   @ m a x d i a s a t r a z o   >   m b c . d i a s a t r a z o   a n d   m b c . d i a s a t r a z o   < >   0   t h e n   1   e l s e   0   e n d , 
 d i a s m e n o r e s a = c a s e   w h e n   @ c o n d i c i o n   l i k e   ' % p p % '   a n d   m b c . d i a s m e n o r e s a   < >   0   t h e n 
 c a s e   w h e n   m b c . d i a s m e n o r e s a   <   d a t e d i f f ( d a y , @ f e c h a e m i s i o n f a c t , g e t d a t e ( ) )   t h e n   1   e l s e   0   e n d 
 w h e n   @ c o n d i c i o n   l i k e   ' % d i f % '   a n d   m b c . d i a s m e n o r e s a   < >   0   t h e n 
 c a s e   w h e n   m b c . d i a s m e n o r e s a   <   d a t e d i f f ( d a y ,   @ f e c h a e m i s i o n f a c t ,   g e t d a t e ( ) )   t h e n   1   e l s e   0   e n d 
 e l s e   0   e n d , 
 d i a s m a y o r e s a = c a s e   w h e n   @ c o n d i c i o n   l i k e   ' % p p % '   a n d   m b c . d i a s m a y o r e s a   < >   0   t h e n 
 c a s e   w h e n   m b c . d i a s m a y o r e s a   > =   d a t e d i f f ( d d , @ f e c h a e m i s i o n f a c t , @ v e n c i m i e n t o )   t h e n   1   e l s e   0   e n d 
 w h e n   @ c o n d i c i o n   l i k e   ' % d i f % '   a n d   m b c . d i a s m a y o r e s a   < >   0   t h e n 
 c a s e   w h e n   m b c . d i a s m a y o r e s a   < =   d a t e d i f f ( d a y ,   @ f e c h a e m i s i o n f a c t ,   g e t d a t e ( ) )   t h e n   1   e l s e   0   e n d 
 e l s e   0   e n d 
 f r o m   m a v i b o n i f i c a c i o n c o n f   m b c   i n n e r   j o i n   m a v i b o n i f i c a c i o n m o v   m b m v   o n   m b c . i d   =   m b m v . i d b o n i f i c a c i o n 
 i n n e r   j o i n   m a v i b o n i f i c a c i o n c o n d i c i o n   m b c 2   o n   m b c 2 . i d b o n i f i c a c i o n = m b c . i d 
 l e f t   j o i n   m a v i b o n i f i c a c i o n l i n e a   m b l   o n   i d = m b l . i d b o n i f i c a c i o n 
 w h e r e   m b m v . m o v i m i e n t o   =   @ m o v 
 a n d   c o n d i c i o n   =   @ c o n d i c i o n 
 a n d   m b c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ f e c h a e m i s i o n   b e t w e e n   m b c . f e c h a i n i   a n d   m b c . f e c h a f i n 
 a n d   m b c . n o p u e d e a p l i c a r s o l a   =   0 
 a n d   b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l ' 
 ) c o n t   w h e r e   o k   =   0   a n d   d i a s a t r a z o   =   0   a n d   d i a s m e n o r e s a   =   0   a n d   d i a s m a y o r e s a   =   0   )   ) 
 s e l e c t   @ o k   =   1 ,   @ o k r e f   =   ' s e   e x c l u y e   e s t a   b o n i f i c a c i o n   p o r   o t r a ' 
 i f   @ v e n c i m i e n t o a n t e s   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % a d e l a n t o % '   a n d   @ t i p o   =   ' t o t a l ' 
 b e g i n 
 s e t   @ c h a r r e f e r e n c i a   =   ' ( '   +   r t r i m ( @ v e n c i m i e n t o a n t e s )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l ) 
 i f   @ e s o r i g e n n u l o = 0 
 b e g i n 
 i f   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   > =   d b o . f n f e c h a s i n h o r a ( ( s e l e c t   c . v e n c i m i e n t o + 1   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d   a n d   c . r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   l � m i t e   d e   p a   p o s t e r i o r 1 ' 
 e n d 
 e l s e 
 b e g i n 
 i f   (   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   >   d b o . f n f e c h a s i n h o r a ( i s n u l l ( ( s e l e c t   c . v e n c i m i e n t o   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d 
 a n d   c . r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) , 
 ( c a s e   w h e n   @ v e n c i m i e n t o a n t e s = 1   t h e n   @ v e n c i m i e n t o 
 w h e n   @ v e n c i m i e n t o a n t e s > 1   t h e n   d a t e a d d ( m m ,   ( @ v e n c i m i e n t o a n t e s   -   @ d o c u m e n t o 1 d e ) ,   ( s e l e c t   v e n c i m i e n t o   f r o m   c x c   w h e r e   o r i g e n = @ o r i g e n   a n d   o r i g e n i d = @ o r i g e n i d   a n d   r e f e r e n c i a = @ r e f e r e n c i a )   )   e n d   )   )   )   ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   l � m i t e   d e   p a   p o s t e r i o r 1 ' 
 e n d 
 e n d 
 i f   @ v e n c i m i e n t o a n t e s   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   @ t i p o   =   ' t o t a l ' 
 b e g i n 
 s e t   @ c h a r r e f e r e n c i a   =   ' ( '   +   r t r i m ( @ v e n c i m i e n t o a n t e s )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l ) 
 i f   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   > =   d b o . f n f e c h a s i n h o r a ( ( s e l e c t   c . v e n c i m i e n t o   +   1   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d   a n d   c . r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   l � m i t e   d e   p a   p o s t e r i o r 1 ' 
 e n d 
 i f   @ v e n c i m i e n t o d e s p   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   @ t i p o   =   ' t o t a l ' 
 b e g i n 
 s e t   @ c h a r r e f e r e n c i a   =   ' ( '   +   r t r i m ( @ v e n c i m i e n t o d e s p )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l ) 
 i f   ( d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   < = 
 d b o . f n f e c h a s i n h o r a ( i s n u l l ( ( s e l e c t   c . v e n c i m i e n t o   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d 
 a n d   c . r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) , 
 ( c a s e   w h e n   @ v e n c i m i e n t o d e s p = 1   t h e n   @ v e n c i m i e n t o 
 w h e n   @ v e n c i m i e n t o d e s p > 1   t h e n   d a t e a d d ( m m ,   ( @ v e n c i m i e n t o d e s p   -   @ d o c u m e n t o 1 d e ) ,   ( s e l e c t   v e n c i m i e n t o   f r o m   c x c   w h e r e   o r i g e n = @ o r i g e n   a n d   o r i g e n i d = @ o r i g e n i d   a n d   r e f e r e n c i a = @ r e f e r e n c i a )   )   e n d   )   )   )   ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   l � m i t e   d e   p a   p o s t e r i o r 1 ' 
 e n d 
 i f   @ d i a s a t r a z o   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i f   @ m a x d i a s a t r a z o   >   @ d i a s a t r a z o   s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   e l   n � m e r o   d e   d i a s   d e   a t r a s o   p e r m i t i d o s   ' 
 e n d 
 i f   @ d i a s m e n o r e s a   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   a n d   @ c o n d i c i o n   l i k e   ' % p p % ' 
 b e g i n 
 i f   @ d i a s m e n o r e s a   <   d a t e d i f f ( d a y , @ f e c h a e m i s i o n f a c t , g e t d a t e ( ) )   s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   d � a s   m e n o r e s ' 
 e n d 
 i f   @ d i a s m a y o r e s a   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   a n d   @ c o n d i c i o n   l i k e   ' % p p % ' 
 b e g i n 
 i f   @ d i a s m a y o r e s a   > =   d a t e d i f f ( d d , @ f e c h a e m i s i o n f a c t , @ v e n c i m i e n t o )   s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   d i a s   m a y o r e s ' 
 e n d 
 i f   @ d i a s m e n o r e s a   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   a n d   @ c o n d i c i o n   l i k e   ' % d i f % ' 
 b e g i n 
 i f   @ d i a s m e n o r e s a   <   d a t e d i f f ( d a y , @ f e c h a e m i s i o n f a c t ,   g e t d a t e ( )   ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   d � a s   m e n o r e s '   +   c o n v e r t   ( c h a r ( 3 0 ) , @ d i a s m e n o r e s a ) 
 e n d 
 i f   @ d i a s m a y o r e s a   < >   0   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   a n d   @ c o n d i c i o n   l i k e   ' % d i f % ' 
 b e g i n 
 i f   g e t d a t e ( )   > =   ( @ f e c h a e m i s i o n f a c t   +   @ d i a s m a y o r e s a ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   d � a s   m a y o r e s '   +   c o n v e r t   ( c h a r ( 3 0 ) , @ d i a s m a y o r e s a ) 
 e n d 
 i f   @ p o r c b o n 1   =   0   a n d   @ l i n e a   < >   0   s e l e c t   @ p o r c b o n 1   =   @ l i n e a 
 i f   @ l i n e a   <   ( s e l e c t   i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   w h e r e   i d b o n i f i c a c i o n = @ i d   a n d   l i n e a   =   @ l i n e a v t a ) 
 s e l e c t   @ l i n e a   =   ( s e l e c t   i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   w h e r e   i d b o n i f i c a c i o n = @ i d   a n d   l i n e a   =   @ l i n e a v t a ) 
 s e l e c t   @ l i n e a c e l u l a r e s = i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   m b l   w h e r e   l i n e a   l i k e   ' % c r e d i l a n a % '   a n d   i d b o n i f i c a c i o n   =   @ i d 
 s e l e c t   @ l i n e a c r e d i l a n a s = i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   m b l   w h e r e   l i n e a   l i k e   ' % c e l u l a r % '   a n d   i d b o n i f i c a c i o n   =   @ i d 
 s e l e c t   @ l i n e a m o t o s = i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   m b l   i n n e r   j o i n   m a v i b o n i f i c a c i o n c o n d i c i o n   m b c   o n   m b c . i d b o n i f i c a c i o n = m b l . i d b o n i f i c a c i o n 
 w h e r e   m b c . c o n d i c i o n = @ c o n d i c i o n   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 a n d   m b l . i d b o n i f i c a c i o n   =   @ i d   a n d   l i n e a = @ l i n e a b o n i f 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c a n a l v t a   b o n c a n   w h e r e   b o n c a n . i d b o n i f i c a c i o n = @ i d ) 
 b e g i n 
 i f   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c a n a l v t a   b o n c a n   w h e r e   c o n v e r t ( v a r c h a r ( 1 0 ) , b o n c a n . c a n a l v e n t a ) = @ c l i e n t e e n v i a r a   a n d   b o n c a n . i d b o n i f i c a c i o n = @ i d ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' v e n t a   d e   c a n a l   n o   c o n f i g u r a d a   p a r a   e s t a   b o n i f i c a c i � n ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n u e n   m b u   w h e r e   m b u . i d b o n i f i c a c i o n = @ i d ) 
 b e g i n 
 i f   n o t   @ u e n   i s   n u l l   a n d   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n u e n   m b u   w h e r e   m b u . u e n   =   @ u e n   a n d   m b u . i d b o n i f i c a c i o n = @ i d ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' u e n   n o   c o n f i g u r a d a   p a r a   e s t e   c a s o ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c o n d i c i o n   w h e r e   i d b o n i f i c a c i o n = @ i d ) 
 b e g i n 
 i f   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c o n d i c i o n   w h e r e   c o n d i c i o n = @ c o n d i c i o n   a n d   i d b o n i f i c a c i o n = @ i d ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' c o n d i c i o n   n o   c o n f i g u r a d a   p a r a   e s t a   b o n i f i c a c i � n ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n e x c l u y e   e x c   w h e r e   b o n i f i c a c i o n n o = @ b o n i f i c a c i o n ) 
 b e g i n 
 i f   e x i s t s ( s e l e c t   b o n t e s t . i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n t e s t   b o n t e s t   ,   m a v i b o n i f i c a c i o n e x c l u y e   e x c   w h e r e   b o n t e s t . i d b o n i f i c a c i o n   =   e x c . i d b o n i f i c a c i o n 
 a n d   b o n t e s t . o k r e f   =   ' '   a n d   e x c . b o n i f i c a c i o n n o = @ b o n i f i c a c i o n   a n d   b o n t e s t . i d c o b r o   =   @ i d c o b r o 
 a n d   b o n t e s t . m o n t o b o n i f   >   0   a n d   b o n t e s t . o r i g e n   =   @ m o v   a n d   b o n t e s t . o r i g e n i d   =   @ m o v i d 
 ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c l u y e   e s t a   b o n i f i c a c i o n   u n a   a n t e r i o r   ' 
 e n d 
 i f   n o t   @ t i p o s u c u r s a l   i s   n u l l   a n d   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n s u c u r s a l   w h e r e   s u c u r s a l = r t r i m ( @ t i p o s u c u r s a l )   a n d   i d b o n i f i c a c i o n = r t r i m ( @ i d ) ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' b o n i f i c a c i � n   n o   c o n f i g u r a d a   p a r a   e s t e   t i p o   d e   s u c u r s a l ' 
 i f   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n t e s t   w h e r e   i d b o n i f i c a c i o n = r t r i m ( @ i d )   a n d   d o c t o   =   @ i d c x c   ) 
 b e g i n 
 s e l e c t   @ m e s e s e x c e d   =   i s n u l l ( @ d o c u m e n t o t o t a l , 0 )   -   i s n u l l ( @ p l a z o e j e f i n , 0 ) 
 s e l e c t   @ f a c t o r   =   1   +   ( @ m e s e s e x c e d   *   ( i s n u l l ( @ f i n a n c i a m i e n t o , 0 . 0 0 ) / 1 0 0 ) ) 
 s e l e c t   @ b a s e p a r a a p l i c a r   =   i s n u l l ( @ i m p o r t e v e n t a   /   @ f a c t o r , 0 . 0 0 ) 
 i f   @ a p l i c a a   =   ' i m p o r t e   d e   f a c t u r a ' 
 b e g i n 
 i f   @ l i n e a   < >   0   s e l e c t   @ p o r c b o n 1 = @ l i n e a 
 i f   @ l i n e a c e l u l a r e s   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o % '   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % a t r a s o % '   s e l e c t   @ p o r c b o n 1 = i s n u l l ( @ l i n e a c e l u l a r e s , 0 . 0 0 ) 
 i f   @ l i n e a c r e d i l a n a s   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o % '   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % a t r a s o % '   s e l e c t   @ p o r c b o n 1 = i s n u l l ( @ l i n e a c r e d i l a n a s , 0 . 0 0 ) 
 i f   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o % '   s e l e c t   @ p o r c b o n 1 = i s n u l l ( @ l i n e a m o t o s , @ p o r c b o n 1 ) 
 s e l e c t   @ m o n t o b o n i f   =   ( @ p o r c b o n 1 / 1 0 0 )   *   ( @ i m p o r t e v e n t a   /   @ f a c t o r ) 
 e n d 
 i f   @ a p l i c a a   < >   ' i m p o r t e   d e   f a c t u r a '   s e l e c t   @ m o n t o b o n i f   =   ( @ p o r c b o n 1 / 1 0 0 )   *   @ i m p o r t e d o c t o 
 i f   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   a n d   @ o k   i s   n u l l 
 b e g i n 
 s e l e c t   @ m o n t o b o n i f   =   @ i m p o r t e v e n t a   -   ( ( @ i m p o r t e v e n t a   /   @ f a c t o r ) - @ m o n t o b o n i f ) 
 e n d 
 i f   n o t   @ o k   i s   n u l l   s e l e c t   @ m o n t o b o n i f   =   0 . 0 0 , @ p o r c b o n 1   =   0 . 0 0 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   =   d b o . f n f e c h a s i n h o r a ( @ v e n c i m i e n t o )   s e l e c t   @ m o n t o b o n i f   =   0 . 0 0   ,   @ p o r c b o n 1   =   0 . 0 0 
 i f   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   a n d   @ o k   i s   n u l l 
 s e l e c t   @ m o n t o b o n i f = i s n u l l ( @ m o n t o b o n i f , 0 ) - b o n i f   f r o m   ( 
 s e l e c t   c m o v . m o v , c m o v . m o v i d , b o n i f = i s n u l l (   s u m ( c d . i m p o r t e ) , 0 )   f r o m   c x c   c m o v   i n n e r   j o i n   c x c   c c t e   o n   c c t e . c l i e n t e = c m o v . c l i e n t e   a n d   c c t e . m o v   l i k e   ' n o t a   c r e d i t o % '   a n d   c c t e . e s t a t u s = ' c o n c l u i d o ' 
 i n n e r   j o i n   c x c   c b o n i f   o n   c c t e . i d = c b o n i f . i d 
 i n n e r   j o i n   c x c d   c d   o n   c b o n i f . i d   =   c d . i d 
 i n n e r   j o i n   c x c   c p a d r e   o n   c p a d r e . m o v = c d . a p l i c a   a n d   c p a d r e . m o v i d = c d . a p l i c a i d   a n d   c p a d r e . p a d r e m a v i = c m o v . m o v   a n d   c p a d r e . p a d r e i d m a v i = c m o v . m o v i d 
 w h e r e   c c t e . c o n c e p t o   l i k e   ' % p a   p u n t u a l % '   a n d   c m o v . m o v = @ m o v   a n d   c m o v . m o v i d = @ m o v i d 
 g r o u p   b y   c m o v . m o v , c m o v . m o v i d 
 ) r e s t a 
 i f   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i n s e r t   m a v i b o n i f i c a c i o n t e s t   ( i d b o n i f i c a c i o n , i d c o b r o , d o c t o ,   b o n i f i c a c i o n ,   e s t a c i o n ,   d o c u m e n t o 1 d e , d o c u m e n t o t o t a l , m o v , 
 m o v i d ,   o r i g e n , o r i g e n i d ,   i m p o r t e d o c t o , i m p o r t e v e n t a ,   m o n t o b o n i f ,   t i p o s u c u r s a l , l i n e a v t a , i d v e n t a , u e n , c o n d i c i o n , p o r c b o n 1 , f i n a n c i a m i e n t o ,   o k , o k r e f ,   f a c t o r , s u c u r s a l 1 , p l a z o e j e f i n ,   f e c h a e m i s i o n ,   v e n c i m i e n t o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s , d i a s m e n o r e s a , d i a s m a y o r e s a , b a s e p a r a a p l i c a r ) 
 v a l u e s ( @ i d   , @ i d c o b r o , @ i d c x c , i s n u l l ( @ b o n i f i c a c i o n , ' ' ) ,   @ e s t a c i o n ,   i s n u l l ( @ d o c u m e n t o 1 d e , 0 ) , i s n u l l ( @ d o c u m e n t o t o t a l , 0 ) , i s n u l l ( @ m o v , ' ' ) , 
 i s n u l l ( @ m o v i d , ' ' ) , i s n u l l ( @ o r i g e n , ' ' ) , i s n u l l ( @ o r i g e n i d , ' ' ) ,   r o u n d ( i s n u l l ( @ i m p o r t e d o c t o , 0 . 0 0 ) , 2 ) ,   r o u n d ( i s n u l l ( @ i m p o r t e v e n t a , 0 . 0 0 ) , 2 ) , 
 r o u n d ( i s n u l l ( @ m o n t o b o n i f , 0 . 0 0 ) , 2 )   ,   i s n u l l ( @ t i p o s u c u r s a l , ' ' ) , i s n u l l ( @ l i n e a v t a , ' ' ) , i s n u l l ( @ i d v e n t a , 0 ) , i s n u l l ( @ u e n , 0 ) , i s n u l l ( @ c o n d i c i o n , ' ' ) , i s n u l l ( @ p o r c b o n 1 , 0 . 0 0 ) ,   i s n u l l ( @ f i n a n c i a m i e n t o , 0 . 0 0 ) ,   i s n u l l ( @ o k , 0 ) , i s n u l l ( @ o k r e f , ' ' ) , i s n u l l ( @ f a c t o r , 0 . 0 0 ) , @ s u c u r s a l , @ p l a z o e j e f i n , @ f e c h a e m i s i o n , @ v e n c i m i e n t o ,   i s n u l l ( @ l i n e a c e l u l a r e s , 0 . 0 0 ) ,   i s n u l l ( @ l i n e a c r e d i l a n a s , 0 . 0 ) , @ d i a s m e n o r e s a , @ d i a s m a y o r e s a , r o u n d ( i s n u l l ( @ b a s e p a r a a p l i c a r , 0 . 0 0 ) , 2 ) ) 
 e n d 
 e n d 
 i f   ( @ o k   i s   n u l l   a n d   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n i n c l u y e   e x c   w h e r e   e x c . i d b o n i f i c a c i o n = @ i d ) 
 a n d   e x i s t s   ( s e l e c t   m o v i m i e n t o   f r o m   m a v i b o n i f i c a c i o n m o v   w h e r e   m o v i m i e n t o   =   @ m o v   a n d   i d b o n i f i c a c i o n   i n 
 ( s e l e c t   i d   f r o m   m a v i b o n i f i c a c i o n c o n f   w h e r e   b o n i f i c a c i o n   l i k e   ' % a t r a s o % '   ) ) )   o r 
 ( @ o k   i s   n u l l   a n d   @ t i p o   =   ' t o t a l '   a n d   n o t   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' )   o r 
 ( @ o k   i s   n u l l   a n d   @ t i p o   =   ' t o t a l '   a n d   n o t   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % ' )   o r 
 ( @ o k   i s   n u l l   a n d   @ t i p o   < >   ' t o t a l '   a n d   n o t   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' ) 
 b e g i n 
 i f   ( @ o k   i s   n u l l   a n d   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n i n c l u y e   e x c   w h e r e   e x c . i d b o n i f i c a c i o n = @ i d ) 
 a n d   e x i s t s   ( s e l e c t   m o v i m i e n t o   f r o m   m a v i b o n i f i c a c i o n m o v   w h e r e   m o v i m i e n t o   =   @ m o v   a n d   i d b o n i f i c a c i o n   i n 
 (   s e l e c t   i d   f r o m   m a v i b o n i f i c a c i o n c o n f   w h e r e   b o n i f i c a c i o n   l i k e   ' % a t r a s o % '   ) ) ) 
 b e g i n 
 i f   e x i s t s ( s e l e c t   *   f r o m   t e m p d b . s y s . s y s o b j e c t s   w h e r e   i d = o b j e c t _ i d ( ' t e m p d b . d b o . # c r v e r i f i c a d e t a l l e ' )   a n d   t y p e   = ' u ' ) 
 d r o p   t a b l e   # c r v e r i f i c a d e t a l l e 
 s e l e c t   r o w _ n u m b e r ( )   o v e r   ( o r d e r   b y   b o n i f i c a c i o n n o   ) i n d   ,   b o n i f i c h i j o   =   b o n i f i c a c i o n n o ,   b o n i f i c h i j o c a s c a d   =   e n c a s c a d a 
 i n t o   # c r v e r i f i c a d e t a l l e 
 f r o m   m a v i b o n i f i c a c i o n i n c l u y e   w h e r e   i d b o n i f i c a c i o n   =   @ i d 
 o r d e r   b y   o r d e n 
 s e t   @ t i n c l u y e   = 0 
 s e t   @ a v a n z a   =   0 
 s e l e c t   @ t i n c l u y e   =   m a x ( i n d ) , @ a v a n z a   =   1   f r o m   # c r v e r i f i c a d e t a l l e 
 w h i l e   @ a v a n z a   < =   @ t i n c l u y e   a n d   @ o k   i s   n u l l 
 b e g i n 
 s e l e c t   @ b o n i f i c h i j o   =   b o n i f i c h i j o   ,   @ b o n i f i c h i j o c a s c a d   =   b o n i f i c h i j o c a s c a d 
 f r o m   # c r v e r i f i c a d e t a l l e 
 w h e r e   i n d   =   @ a v a n z a 
 i f   r t r i m ( @ b o n i f i c h i j o )   l i k e   ' % a t r a s o % '   a n d   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   s e l e c t   @ b a s e p a r a a p l i c a r   =   @ i m p o r t e v e n t a 
 i f   r t r i m ( @ b o n i f i c h i j o )   l i k e   ' % a t r a s o % '   a n d   @ b o n i f i c a c i o n   l i k e   ' % c o m e r c i a l % '   s e l e c t   @ b a s e p a r a a p l i c a r   =   @ i m p o r t e v e n t a   *   ( @ p o r c b o n 1 / 1 0 0 ) 
 e x e c   s p b o n i f i c a c i o n d o c r e s t a n t e s   @ b o n i f i c h i j o , @ b o n i f i c h i j o c a s c a d ,   @ p a d r e m a v i ,   @ p a d r e m a v i i d   , @ i d v e n t a   ,   @ l i n e a v t a , 
 @ s u c u r s a l   ,   @ t i p o s u c u r s a l ,   @ e s t a c i o n   , @ u e n , @ c o n d i c i o n ,   @ i m p o r t e v e n t a ,   @ t i p o ,   @ i d c x c ,   @ i d c o b r o , @ m a x d i a s a t r a z o ,   @ i d , @ b o n i f i c a c i o n , @ b a s e p a r a a p l i c a r ,   ' i n c l u y e ' ,   @ m o n t o b o n i f ,   @ f e c h a e m i s i o n 
 s e t   @ a v a n z a   =   @ a v a n z a   +   1 
 e n d 
 e n d 
 i f   ( @ o k   i s   n u l l   a n d   @ t i p o   =   ' t o t a l '   a n d   n o t   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' )   o r 
 ( @ o k   i s   n u l l   a n d   @ t i p o   < >   ' t o t a l '   a n d   n o t   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' ) 
 b e g i n 
 e x e c   s p b o n i f i c a c i o n d o c r e s t a n t e s   @ b o n i f i c a c i o n , ' n o ' ,   @ p a d r e m a v i ,   @ p a d r e m a v i i d   , @ i d v e n t a   ,   @ l i n e a v t a , 
 @ s u c u r s a l   ,   @ t i p o s u c u r s a l ,   @ e s t a c i o n   , @ u e n , @ c o n d i c i o n ,   @ i m p o r t e v e n t a ,   @ t i p o ,   @ i d c x c , @ i d c o b r o ,   @ m a x d i a s a t r a z o ,   @ i d ,   @ b o n i f i c a c i o n ,   @ b a s e p a r a a p l i c a r ,   ' ' ,   @ m o n t o b o n i f ,   @ f e c h a e m i s i o n 
 e n d 
 e n d 
 s e t   @ r e c o r r e   =   @ r e c o r r e + 1 
 e n d 
 e n d 