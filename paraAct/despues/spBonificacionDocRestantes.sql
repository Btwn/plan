u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p b o n i f i c a c i o n d o c r e s t a n t e s ] 
 @ b o n i f i c a c i o n   v a r c h a r ( 5 0 ) , 
 @ e n c a s c a d a   v a r c h a r ( 5 ) , 
 @ o r i g e n   v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d   v a r c h a r ( 2 0 ) , 
 @ i d v e n t a   i n t , 
 @ l i n e a v t a   v a r c h a r ( 5 0 ) , 
 @ s u c u r s a l   i n t , 
 @ t i p o s u c u r s a l   v a r c h a r ( 5 0 ) , 
 @ e s t a c i o n   i n t , 
 @ u e n   i n t , 
 @ c o n d i c i o n   v a r c h a r ( 5 0 ) , 
 @ i m p o r t e v e n t a   f l o a t , 
 @ t i p o   v a r c h a r ( 1 0 ) , 
 @ i d c x c   i n t   , 
 @ i d c o b r o   i n t , 
 @ m a x d i a s a t r a z o   f l o a t , 
 @ i d b o n i f i c a   i n t , 
 @ s t r b o n i f i c a   v a r c h a r ( 5 0 ) , 
 @ b a s e p a r a a p l i c a r   f l o a t , 
 @ i n c l u y e   c h a r ( 1 0 ) , 
 @ m o n t o b o n i f p a p a   f l o a t   , 
 @ f e c h a e m i s i o n b a s e   d a t e t i m e 
 a s 
 b e g i n 
 d e c l a r e 
 @ e m p r e s a   v a r c h a r ( 5 ) , 
 @ m o v   v a r c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ t i p o c a m b i o   f l o a t , 
 @ c l i e n t e e n v i a r a   i n t , 
 @ v e n c i m i e n t o   d a t e t i m e , 
 @ i m p u e s t o s   f l o a t , 
 @ s a l d o   f l o a t , 
 @ i m p o r t e d o c t o   f l o a t , 
 @ i m p o r t e c a s c a   f l o a t , 
 @ r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ d o c u m e n t o 1 d e   i n t , 
 @ d o c u m e n t o t o t a l   i n t , 
 @ o r i g e n t i p o   v a r c h a r ( 2 0 ) , 
 @ e x t r a e d   i n t , 
 @ e x t r a e a   i n t , 
 @ m o v i d v e n t a   v a r c h a r ( 2 0 ) , 
 @ m o v v e n t a   v a r c h a r ( 2 0 ) , 
 @ d i a s m e n o r e s a   i n t , 
 @ d i a s m a y o r e s a   i n t , 
 @ i d   i n t , 
 @ i d b o n i f i c a c i o n   i n t , 
 @ e s t a t u s   v a r c h a r ( 1 5 ) , 
 @ p o r c b o n 1   f l o a t , 
 @ p o r c b o n 1 b a s   f l o a t , 
 @ m o n t o b o n i f   f l o a t , 
 @ f i n a n c i a m i e n t o   f l o a t , 
 @ f e c h a i n i   d a t e t i m e , 
 @ f e c h a f i n   d a t e t i m e , 
 @ p a t o t a l   b i t , 
 @ a c t v i g e n c i a   b i t , 
 @ c a s c a d a c a l c   b i t , 
 @ a p l i c a a   c h a r ( 3 0 ) , 
 @ p l a z o e j e f i n   i n t , 
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
 @ n o p u e d e a p l i c a r s o l a   b i t , 
 @ e j e r c i c i o   i n t , 
 @ l i n e a c e l u l a r e s   f l o a t , 
 @ l i n e a c r e d i l a n a s   f l o a t , 
 @ i m p o r t e v e n t a 2   f l o a t , 
 @ l i n e a m o t o s   v a r c h a r ( 2 5 ) , 
 @ m e s e s a d e l a n t o   i n t 
 , @ d v e x t r a   i n t 
 ,   @ p o r c b o n e x t r a   f l o a t 
 i f   e x i s t s ( s e l e c t   *   f r o m   t e m p d b . s y s . s y s o b j e c t s   w h e r e   i d = o b j e c t _ i d ( ' t e m p d b . . # m o v s p e n d i e n t e s ' )   a n d   t y p e = ' u ' ) 
 d r o p   t a b l e   # m o v s p e n d i e n t e s 
 s e l e c t   i d ,   e m p r e s a , m o v , m o v i d ,   f e c h a e m i s i o n , c o n c e p t o ,   e s t a t u s , 
 c l i e n t e e n v i a r a , v e n c i m i e n t o , i m p o r t e ,   i m p u e s t o s , s a l d o , r e f e r e n c i a , 
 p a d r e m a v i ,   p a d r e i d m a v i 
 i n t o   # m o v s p e n d i e n t e s 
 f r o m   c x c p e n d i e n t e   c p   w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   n o t   r e f e r e n c i a   i s   n u l l   a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 u p d a t e   m   s e t   i m p o r t e   =   c a l c . c a l c u l o , i m p u e s t o s = c a s t ( 0 . 0 0   a s   m o n e y ) 
 f r o m   # m o v s p e n d i e n t e s   m 
 i n n e r   j o i n   ( 
 s e l e c t 
 i m p o r t e   =   d o c . i m p o r t e + d o c . i m p u e s t o s , 
 d o c u m e n t o s   =   c o n . d a n u m e r o d o c u m e n t o s , 
 d o c . p a d r e m a v i , 
 d o c . p a d r e i d m a v i , 
 m o n e d e r o   =   i s n u l l ( m o n . a b o n o , 0 ) , 
 c a l c u l o   =   ( ( ( d o c . i m p o r t e + d o c . i m p u e s t o s ) ) - i s n u l l ( m o n . a b o n o , 0 ) ) / c o n . d a n u m e r o d o c u m e n t o s 
 f r o m   d b o . c x c   d o c   l e f t   j o i n   d b o . c o n d i c i o n   c o n   o n   c o n . c o n d i c i o n = d o c . c o n d i c i o n 
 l e f t   j o i n   d b o . a u x i l i a r p   m o n   o n   m o n . m o v = d o c . m o v   a n d   m o n . m o v i d = d o c . m o v i d   a n d   i s n u l l ( m o n . a b o n o , 0 ) > 0 
 w h e r e   d o c . m o v = @ o r i g e n   a n d   d o c . m o v i d = @ o r i g e n i d   a n d   d o c . e s t a t u s < > ' c a n c e l a d o ' 
 ) c a l c   o n   c a l c . p a d r e m a v i = m . p a d r e m a v i   a n d   c a l c . p a d r e i d m a v i = m . p a d r e i d m a v i 
 s e l e c t   @ o k   =   n u l l   ,   @ o k r e f   =   ' ' ,   @ e j e r c i c i o   =   y e a r ( g e t d a t e ( ) ) ,   @ p e r i o d o   =   m o n t h ( g e t d a t e ( ) ) ,   @ m o v   =   ' ' , @ d i a s m e n o r e s a = 0 ,   @ d i a s m a y o r e s a = 0 ,   @ c h a r r e f e r e n c i a =   0   ,   @ i m p o r t e c a s c a = 0 . 0 0 
 s e l e c t   @ i m p o r t e v e n t a 2   =   0 . 0 0 
 s e l e c t   @ m o v   =   m o v   f r o m   c x c   w h e r e   i d   =   @ i d c x c 
 i f   @ i n c l u y e   =   ' i n c l u y e ' 
 s e l e c t 
 @ i d b o n i f i c a c i o n   =   i d , @ p o r c b o n 1 b a s   =   p o r c b o n 1 , @ f i n a n c i a m i e n t o   =   f i n a n c i a m i e n t o , @ f e c h a i n i   =   f e c h a i n i , 
 @ f e c h a f i n   =   f e c h a f i n , @ p a t o t a l   =   p a t o t a l , @ a p l i c a a   =   a p l i c a a , @ p l a z o e j e f i n   =   p l a z o e j e f i n , @ v e n c i m i e n t o a n t e s   =   v e n c i m i e n t o a n t e s , 
 @ v e n c i m i e n t o d e s p   =   v e n c i m i e n t o d e s p , @ d i a s a t r a z o   =   d i a s a t r a z o , @ d i a s m e n o r e s a   =   d i a s m e n o r e s a , @ d i a s m a y o r e s a   =   d i a s m a y o r e s a , 
 @ f a c t o r   =   f a c t o r , @ l i n e a   =   l i n e a ,   @ n o p u e d e a p l i c a r s o l a   =   i s n u l l ( n o p u e d e a p l i c a r s o l a , 0 ) 
 f r o m 
 ( 
 s e l e c t   i d ,   p o r c b o n 1 ,   f i n a n c i a m i e n t o ,   f e c h a i n i ,   f e c h a f i n ,   p a t o t a l ,   a p l i c a a ,   p l a z o e j e f i n ,   v e n c i m i e n t o a n t e s , 
 v e n c i m i e n t o d e s p ,   d i a s a t r a z o ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   f a c t o r ,   l i n e a ,   n o p u e d e a p l i c a r s o l a 
 , r o w _ n u m b e r ( )   o v e r   ( p a r t i t i o n   b y   b o n i f i c a c i o n   o r d e r   b y   i d )   p e r b o n i f 
 f r o m   m a v i b o n i f i c a c i o n c o n f   j o i n   m a v i b o n i f i c a c i o n m o v   b m   o n   i d   =   b m . i d b o n i f i c a c i o n 
 w h e r e   b o n i f i c a c i o n   =   @ b o n i f i c a c i o n 
 a n d   e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   f e c h a i n i   < =   @ f e c h a e m i s i o n b a s e   a n d   f e c h a f i n   > =   @ f e c h a e m i s i o n b a s e 
 a n d   b m . m o v i m i e n t o   =   @ m o v 
 ) b o n i 
 w h e r e   p e r b o n i f   =   1 
 s e l e c t   @ m o v   =   ' ' 
 i f   @ i n c l u y e   < >   ' i n c l u y e ' 
 s e l e c t 
 @ i d b o n i f i c a c i o n   =   i d , @ p o r c b o n 1 b a s   =   p o r c b o n 1 , @ f i n a n c i a m i e n t o   =   f i n a n c i a m i e n t o , @ f e c h a i n i   =   f e c h a i n i , 
 @ f e c h a f i n   =   f e c h a f i n , @ p a t o t a l   =   p a t o t a l , @ a p l i c a a   =   a p l i c a a , @ p l a z o e j e f i n   =   p l a z o e j e f i n , @ v e n c i m i e n t o a n t e s   =   v e n c i m i e n t o a n t e s , 
 @ v e n c i m i e n t o d e s p   =   v e n c i m i e n t o d e s p , @ d i a s a t r a z o   =   d i a s a t r a z o , @ d i a s m e n o r e s a   =   d i a s m e n o r e s a , @ d i a s m a y o r e s a   =   d i a s m a y o r e s a , 
 @ f a c t o r   =   f a c t o r , @ l i n e a   =   l i n e a ,   @ n o p u e d e a p l i c a r s o l a   =   i s n u l l ( n o p u e d e a p l i c a r s o l a , 0 ) 
 f r o m   m a v i b o n i f i c a c i o n c o n f   w h e r e   b o n i f i c a c i o n   =   @ b o n i f i c a c i o n 
 a n d   i d   =   @ i d b o n i f i c a 
 a n d   e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   f e c h a i n i   < =   @ f e c h a e m i s i o n b a s e   a n d   f e c h a f i n   > =   @ f e c h a e m i s i o n b a s e 
 i f   e x i s t s ( s e l e c t   *   f r o m   t e m p d b . s y s . s y s o b j e c t s   w h e r e   i d = o b j e c t _ i d ( ' t e m p d b . d b o . # c r c x c p e n d i e n t e s ' )   a n d   t y p e   = ' u ' ) 
 d r o p   t a b l e   # c r c x c p e n d i e n t e s 
 c r e a t e   t a b l e   # c r c x c p e n d i e n t e s (   c o n s e c   i n t   i d e n t i t y ,   i d c x c   i n t ,   e m p r e s a   v a r c h a r ( 5 0 ) , m o v   v a r c h a r ( 3 0 )   , m o v i d   v a r c h a r ( 3 0 ) ,   f e c h a e m i s i o n   d a t e t i m e   , 
 c l i e n t e e n v i a r a   i n t , v e n c i m i e n t o   d a t e t i m e   , i m p o r t e d o c t o   f l o a t ,   i m p u e s t o s   f l o a t , s a l d o   f l o a t , c o n c e p t o   v a r c h a r ( 5 0 )   n u l l ,   r e f e r e n c i a   v a r c h a r ( 5 0 )   n u l l   ) 
 i f   @ t i p o   =   ' t o t a l '   a n d   @ n o p u e d e a p l i c a r s o l a   =   0 
 b e g i n 
 i n s e r t   i n t o   # c r c x c p e n d i e n t e s   (   i d c x c   ,   e m p r e s a   , m o v   , m o v i d   ,   f e c h a e m i s i o n   , c l i e n t e e n v i a r a   , v e n c i m i e n t o   , i m p o r t e d o c t o   ,   i m p u e s t o s   , 
 s a l d o   , c o n c e p t o   ,   r e f e r e n c i a   ) 
 s e l e c t   i d ,   e m p r e s a , m o v , m o v i d ,   f e c h a e m i s i o n ,   c l i e n t e e n v i a r a , v e n c i m i e n t o , i m p o r t e ,   i m p u e s t o s , s a l d o , c o n c e p t o , r e f e r e n c i a 
 f r o m   # m o v s p e n d i e n t e s   c p 
 w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   n o t   r e f e r e n c i a   i s   n u l l   a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 u n i o n 
 s e l e c t   c p . i d ,   c p . e m p r e s a , c p . m o v , c p . m o v i d ,   c p . f e c h a e m i s i o n , c p . c l i e n t e e n v i a r a , c p . v e n c i m i e n t o , c p . i m p o r t e ,   c p . i m p u e s t o s , c p . s a l d o , c p . c o n c e p t o , c p . r e f e r e n c i a 
 f r o m   c x c p e n d i e n t e   c p   j o i n   n e c i a m o r a t o r i o s m a v i   n m m   o n ( c p . m o v   =   n m m . m o v   a n d   c p . m o v i d   =   n m m . m o v i d ) 
 w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 a n d   ( n m m . m o v   l i k e   ' % n o t a   c a r % '   o r   n m m . m o v   l i k e   ' % c o n t r a   r e c i b o % ' ) 
 a n d   n m m . i d c o b r o = @ i d c o b r o 
 e n d 
 e l s e   i f   i s n u l l ( @ t i p o , ' ' ) < > ' t o t a l '   a n d   @ n o p u e d e a p l i c a r s o l a   =   0 
 b e g i n 
 i n s e r t   i n t o   # c r c x c p e n d i e n t e s   (   i d c x c   ,   e m p r e s a   , m o v   , m o v i d   ,   f e c h a e m i s i o n   , c l i e n t e e n v i a r a   , v e n c i m i e n t o   , i m p o r t e d o c t o   ,   i m p u e s t o s   , 
 s a l d o   , c o n c e p t o   ,   r e f e r e n c i a   ) 
 s e l e c t   i d ,   e m p r e s a , m o v , m o v i d ,   f e c h a e m i s i o n ,   c l i e n t e e n v i a r a , v e n c i m i e n t o , i m p o r t e ,   i m p u e s t o s , s a l d o , c o n c e p t o , r e f e r e n c i a 
 f r o m   # m o v s p e n d i e n t e s   c p   w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   n o t   r e f e r e n c i a   i s   n u l l   a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 u n i o n 
 s e l e c t   c p . i d ,   c p . e m p r e s a , c p . m o v , c p . m o v i d ,   c p . f e c h a e m i s i o n , 
 c p . c l i e n t e e n v i a r a , c p . v e n c i m i e n t o , c p . i m p o r t e ,   c p . i m p u e s t o s , c p . s a l d o , c p . c o n c e p t o , c p . r e f e r e n c i a 
 f r o m   c x c p e n d i e n t e   c p   j o i n   n e c i a m o r a t o r i o s m a v i   n m m   o n ( c p . m o v   =   n m m . m o v   a n d   c p . m o v i d   =   n m m . m o v i d   ) 
 w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 a n d   ( n m m . m o v   l i k e   ' % n o t a   c a r % '   o r   n m m . m o v   l i k e   ' % c o n t r a   r e c i b o % ' ) 
 a n d   n m m . i d c o b r o = @ i d c o b r o 
 e n d 
 s e l e c t   @ d v e x t r a   =   m a x d v ,   @ p o r c b o n e x t r a   = p o r c b o n   f r o m   m a v i b o n i f i c a c i o n c o n v e n c i m i e n t o   w h e r e   i d b o n i f i c a c i o n   =   @ i d b o n i f i c a 
 i f   @ n o p u e d e a p l i c a r s o l a   =   1 
 b e g i n 
 i n s e r t   i n t o   # c r c x c p e n d i e n t e s   (   i d c x c   ,   e m p r e s a   , m o v   , m o v i d   ,   f e c h a e m i s i o n   , c l i e n t e e n v i a r a   , v e n c i m i e n t o   , i m p o r t e d o c t o   ,   i m p u e s t o s   , 
 s a l d o   , c o n c e p t o   ,   r e f e r e n c i a   ) 
 s e l e c t   t o p ( 1 ) i d ,   e m p r e s a , m o v , m o v i d ,   f e c h a e m i s i o n ,   c l i e n t e e n v i a r a , v e n c i m i e n t o , i m p o r t e ,   i m p u e s t o s , s a l d o , c o n c e p t o , r e f e r e n c i a 
 f r o m   # m o v s p e n d i e n t e s   c p 
 w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   n o t   r e f e r e n c i a   i s   n u l l   a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 e n d 
 i f   @ i d b o n i f i c a c i o n   i s   n o t   n u l l 
 b e g i n 
 d e c l a r e   @ t o t r e g   i n t   ,   @ r e c o r r e   i n t 
 s e l e c t   @ t o t r e g   = m a x ( c o n s e c )   ,   @ r e c o r r e   =   1   f r o m   # c r c x c p e n d i e n t e s 
 w h i l e   @ r e c o r r e   < =   @ t o t r e g 
 b e g i n 
 s e l e c t   @ i d c x c   =   i d c x c   ,   @ e m p r e s a   =   e m p r e s a   , @ m o v   =   m o v   , @ m o v i d   = m o v i d   ,   @ f e c h a e m i s i o n   = f e c h a e m i s i o n   , @ c o n c e p t o   =   c o n c e p t o , 
 @ c l i e n t e e n v i a r a   = c l i e n t e e n v i a r a , @ v e n c i m i e n t o   =   v e n c i m i e n t o , @ i m p o r t e d o c t o   =   i m p o r t e d o c t o ,   @ i m p u e s t o s   =   i m p u e s t o s , @ s a l d o   =   s a l d o , 
 @ c o n c e p t o   =   c o n c e p t o   , @ r e f e r e n c i a   = r e f e r e n c i a 
 f r o m   # c r c x c p e n d i e n t e s 
 w h e r e   c o n s e c =   @ r e c o r r e 
 s e l e c t   @ i m p o r t e d o c t o   =   @ i m p o r t e d o c t o   +   i s n u l l ( @ i m p u e s t o s , 0 . 0 0 ) ,   @ p o r c b o n 1   =   @ p o r c b o n 1 b a s ,   @ o k   =   n u l l ,   @ o k r e f   =   ' ' 
 i f   @ m o v   l i k e   ' % n o t a   c a r % ' 
 b e g i n 
 i f   i s n u l l ( @ c o n c e p t o , ' ' )   n o t   l i k e   ' c a n c   c o b r o % ' 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' l a   n o t a   n o   p e r t e n e c e   a   u n   c o n c e p t o   p a r a   b o n i f i c a c i � n ' 
 e n d 
 i f   p a t i n d e x ( ' % / % ' , @ r e f e r e n c i a )   >   0 
 b e g i n 
 s e l e c t   @ e x t r a e d   =   p a t i n d e x ( ' % ( % ' , @ r e f e r e n c i a ) ,   @ e x t r a e a   =   p a t i n d e x ( ' % / % ' , @ r e f e r e n c i a ) 
 s e l e c t   @ d o c u m e n t o 1 d e   =   s u b s t r i n g ( @ r e f e r e n c i a , @ e x t r a e d + 1 , @ e x t r a e a   -   @ e x t r a e d   - 1 ) 
 s e l e c t   @ e x t r a e d   =   p a t i n d e x ( ' % / % ' , @ r e f e r e n c i a ) ,   @ e x t r a e a   =   p a t i n d e x ( ' % ) % ' , @ r e f e r e n c i a ) 
 s e l e c t   @ d o c u m e n t o t o t a l   =   s u b s t r i n g ( @ r e f e r e n c i a , @ e x t r a e d + 1 , @ e x t r a e a   -   @ e x t r a e d   - 1 ) 
 e n d 
 i f   @ v e n c i m i e n t o a n t e s   < >   0   a n d   ( n o t   @ m o v   l i k e   ' % n o t a   c a r % '   o r   n o t   @ m o v   l i k e   ' % c o n t r a % ' ) 
 b e g i n 
 s e t   @ c h a r r e f e r e n c i a   =   r t r i m ( @ v e n c i m i e n t o a n t e s )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l ) 
 i f   n o t   e x i s t s ( s e l e c t   i d   f r o m   c x c p e n d i e n t e   w h e r e   p a d r e m a v i   =   @ o r i g e n   a n d   p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   e s t a t u s   =   ' p e n d i e n t e '   a n d   r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   e l   n � m e r o   m � n i m o   d e l   p a   a   j a l a r ' 
 e n d 
 i f   @ v e n c i m i e n t o d e s p   < =   @ d o c u m e n t o 1 d e   a n d   @ v e n c i m i e n t o d e s p   < >   0   a n d   ( n o t   @ m o v   l i k e   ' % n o t a   c a r % '   o r   n o t   @ m o v   l i k e   ' % c o n t r a % ' ) 
 b e g i n 
 s e t   @ c h a r r e f e r e n c i a   =   r t r i m ( @ d o c u m e n t o 1 d e )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l ) 
 i f   n o t   e x i s t s ( s e l e c t   i d   f r o m   c x c p e n d i e n t e   w h e r e   p a d r e m a v i   =   @ o r i g e n   a n d   p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   e s t a t u s   =   ' p e n d i e n t e '   a n d   r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   e l   n u m e r o   m a x i m o   d e l   p a   a   j a l a r ' 
 e n d 
 i f   @ d i a s a t r a z o   < >   0   a n d   @ m o v   < >   ' n o t a   c a r ' 
 b e g i n 
 i f   @ m a x d i a s a t r a z o   >   @ d i a s a t r a z o   s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   e l   n � m e r o   d e   d i a s   d e   a t r a s o   p e r m i t i d o s   ' 
 e n d 
 i f   @ d i a s m e n o r e s a   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i f   @ d i a s m e n o r e s a   <   d a t e d i f f ( d a y ,   @ f e c h a e m i s i o n ,   g e t d a t e ( )   ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   d � a s   m e n o r e s '   +   c o n v e r t   ( c h a r ( 3 0 ) , @ d i a s m e n o r e s a ) 
 e n d 
 i f   @ d i a s m a y o r e s a   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 b e g i n 
 i f   @ d i a s m a y o r e s a   >   d a t e d i f f ( d a y ,   @ f e c h a e m i s i o n ,   g e t d a t e ( )   ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c e d e   d � a s   m a y o r e s '   +   c o n v e r t   ( c h a r ( 3 0 ) , @ d i a s m a y o r e s a ) 
 e n d 
 i f   @ v e n c i m i e n t o d e s p   < >   0 
 b e g i n 
 s e t   @ c h a r r e f e r e n c i a   =   ' ( '   +   r t r i m ( @ v e n c i m i e n t o d e s p )   +   ' / '   +   r t r i m ( @ d o c u m e n t o t o t a l ) 
 i f   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   < =   d b o . f n f e c h a s i n h o r a ( ( s e l e c t   c . v e n c i m i e n t o   f r o m   c x c   c   w h e r e   c . o r i g e n   =   @ o r i g e n   a n d   c . o r i g e n i d   =   @ o r i g e n i d   a n d   c . r e f e r e n c i a   l i k e   ' % '   +   @ c h a r r e f e r e n c i a   +   ' % ' ) ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' n o   c u m p l e   c o n   e l   l � m i t e   d e   p a   p o s t e r i o r 2 ' 
 e n d 
 i f   @ p o r c b o n 1   =   0   a n d   @ l i n e a   < >   0   s e l e c t   @ p o r c b o n 1   =   @ l i n e a 
 i f   @ l i n e a   <   ( s e l e c t   i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   w h e r e   i d b o n i f i c a c i o n = @ i d   a n d   l i n e a   =   @ l i n e a v t a ) 
 s e l e c t   @ l i n e a   =   ( s e l e c t   i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   w h e r e   i d b o n i f i c a c i o n = @ i d   a n d   l i n e a   =   @ l i n e a v t a ) 
 s e l e c t   @ l i n e a c r e d i l a n a s = i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   m b l   w h e r e   l i n e a   l i k e   ' % c r e d i l a n a % '   a n d   i d b o n i f i c a c i o n   =   @ i d b o n i f i c a c i o n 
 s e l e c t   @ l i n e a c e l u l a r e s = i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   m b l   w h e r e   l i n e a   l i k e   ' % c e l u l a r % '   a n d   i d b o n i f i c a c i o n   =   @ i d b o n i f i c a c i o n 
 s e l e c t   @ l i n e a m o t o s = i s n u l l ( p o r c l i n , 0 . 0 0 )   f r o m   m a v i b o n i f i c a c i o n l i n e a   m b l   w h e r e   l i n e a   l i k e   ' % m o t o c i c l e t a % '   a n d   i d b o n i f i c a c i o n   =   @ i d b o n i f i c a c i o n 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c a n a l v t a   b o n c a n   w h e r e   b o n c a n . i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 b e g i n 
 i f   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c a n a l v t a   b o n c a n   w h e r e   c o n v e r t ( v a r c h a r ( 1 0 ) , b o n c a n . c a n a l v e n t a ) = @ c l i e n t e e n v i a r a   a n d   b o n c a n . i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' v e n t a   d e   c a n a l   n o   c o n f i g u r a d a   p a r a   e s t a   b o n i f i c a c i � n ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n u e n   m b u   w h e r e   m b u . i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 b e g i n 
 i f   n o t   @ u e n   i s   n u l l   a n d   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n u e n   m b u   w h e r e   m b u . u e n   =   @ u e n   a n d   m b u . i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' u e n   n o   c o n f i g u r a d a   p a r a   e s t e   c a s o ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c o n d i c i o n   w h e r e   i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 b e g i n 
 i f   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n c o n d i c i o n   w h e r e   c o n d i c i o n = @ c o n d i c i o n   a n d   i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' c o n d i c i o n   n o   c o n f i g u r a d a   p a r a   e s t a   b o n i f i c a c i � n ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n e x c l u y e   e x c   w h e r e   b o n i f i c a c i o n n o = @ b o n i f i c a c i o n ) 
 b e g i n 
 i f   e x i s t s ( s e l e c t   b o n t e s t . i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n t e s t   b o n t e s t   j o i n   m a v i b o n i f i c a c i o n e x c l u y e   e x c   o n ( b o n t e s t . i d b o n i f i c a c i o n   =   e x c . i d b o n i f i c a c i o n ) 
 w h e r e   e x c . b o n i f i c a c i o n n o = @ b o n i f i c a c i o n   a n d   b o n t e s t . o k r e f   =   ' '   a n d   b o n t e s t . m o n t o b o n i f   >   0 
 a n d   i d c o b r o   =   @ i d c o b r o   a n d   o r i g e n = @ o r i g e n   a n d   o r i g e n i d = @ o r i g e n i d ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' e x c l u y e   e s t a   b o n i f i c a c i o n   u n a   a n t e r i o r   d e t a l l e ' 
 e n d 
 i f   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n s u c u r s a l   e x c   w h e r e   i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 b e g i n 
 i f   n o t   @ t i p o s u c u r s a l   i s   n u l l   a n d   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n s u c u r s a l   w h e r e   s u c u r s a l = @ t i p o s u c u r s a l   a n d   i d b o n i f i c a c i o n = @ i d b o n i f i c a c i o n ) 
 s e l e c t   @ o k = 1 ,   @ o k r e f   =   ' b o n i f i c a c i � n   n o   c o n f i g u r a d a   p a r a   e s t e   t i p o   d e   s u c u r s a l ' 
 e n d 
 i f   n o t   e x i s t s ( s e l e c t   i d b o n i f i c a c i o n   f r o m   m a v i b o n i f i c a c i o n t e s t   w h e r e   i d b o n i f i c a c i o n = r t r i m ( @ i d b o n i f i c a c i o n )   a n d   d o c t o   =   @ i d c x c   a n d   e s t a c i o n   =   @ e s t a c i o n   a n d   m o n t o b o n i f   =   @ m o n t o b o n i f ) 
 b e g i n 
 i f   @ a p l i c a a   =   ' i m p o r t e   d e   f a c t u r a ' 
 b e g i n 
 i f   @ l i n e a   < >   0   s e l e c t   @ p o r c b o n 1 = @ l i n e a 
 i f   @ l i n e a c e l u l a r e s   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o % '   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % a t r a s o % '   s e l e c t   @ p o r c b o n 1 = @ l i n e a c e l u l a r e s 
 i f   @ l i n e a c r e d i l a n a s   < >   0   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o % '   a n d   @ b o n i f i c a c i o n   n o t   l i k e   ' % a t r a s o % '   s e l e c t   @ p o r c b o n 1 = @ l i n e a c r e d i l a n a s 
 i f   @ e n c a s c a d a   =   ' s i '   s e l e c t   @ i m p o r t e v e n t a 2   =   @ i m p o r t e v e n t a   -   @ m o n t o b o n i f p a p a 
 i f   @ e n c a s c a d a   < >   ' s i '   s e l e c t   @ i m p o r t e v e n t a 2   =   @ i m p o r t e v e n t a 
 s e l e c t   @ m o n t o b o n i f   =   ( @ p o r c b o n 1 / 1 0 0 )   *   @ i m p o r t e v e n t a 2 
 e n d 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   @ t i p o   =   ' t o t a l ' 
 b e g i n 
 i f   @ l i n e a   < >   0   s e l e c t   @ p o r c b o n 1 = @ l i n e a 
 i f   i s n u l l ( @ l i n e a c e l u l a r e s , 0 )   < >   0   a n d   @ l i n e a v t a   l i k e   ' % c e l u l a r % '   s e l e c t   @ p o r c b o n 1 = @ l i n e a c e l u l a r e s 
 i f   i s n u l l ( @ l i n e a c r e d i l a n a s , 0 )   < >   0   a n d   @ l i n e a v t a   l i k e   ' % c r e d i l a % '   s e l e c t   @ p o r c b o n 1 = @ l i n e a c r e d i l a n a s 
 i f   @ b o n i f i c a c i o n   l i k e   ' % c o n t a d o % '   s e l e c t   @ p o r c b o n 1 = @ l i n e a m o t o s 
 i f   @ e n c a s c a d a   =   ' s i '   s e l e c t   @ i m p o r t e v e n t a 2   =   @ i m p o r t e v e n t a   -   @ m o n t o b o n i f p a p a 
 i f   @ e n c a s c a d a   < >   ' s i '   s e l e c t   @ i m p o r t e v e n t a 2   =   @ i m p o r t e v e n t a 
 s e l e c t 
 @ m e s e s a d e l a n t o = c o u n t ( i d ) 
 f r o m   c x c   w h e r e   p a d r e m a v i   =   @ o r i g e n   a n d   p a d r e i d m a v i   =   @ o r i g e n i d   a n d   p a d r e m a v i   < >   m o v   a n d   v e n c i m i e n t o > g e t d a t e ( ) 
 i f   @ m e s e s a d e l a n t o   >   @ d o c u m e n t o t o t a l   s e l e c t   @ m e s e s a d e l a n t o   =   @ d o c u m e n t o t o t a l 
 s e l e c t   @ p o r c b o n 1   =   @ p o r c b o n 1   *   @ m e s e s a d e l a n t o 
 s e l e c t   @ i m p o r t e v e n t a 2   =   ( @ i m p o r t e v e n t a 2   /   @ d o c u m e n t o t o t a l )   *   @ m e s e s a d e l a n t o 
 s e l e c t   @ i m p o r t e v e n t a 2   =   @ i m p o r t e v e n t a 2   /   ( s e l e c t   c o u n t ( i d )   f r o m   ( 
 s e l e c t   i d ,   e m p r e s a , m o v , m o v i d ,   f e c h a e m i s i o n , c o n c e p t o , 
 c l i e n t e e n v i a r a , v e n c i m i e n t o , i m p o r t e ,   i m p u e s t o s , s a l d o , r e f e r e n c i a 
 f r o m   c x c   c p   w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   n o t   r e f e r e n c i a   i s   n u l l   a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 u n i o n 
 s e l e c t   c p . i d ,   c p . e m p r e s a , c p . m o v , c p . m o v i d ,   c p . f e c h a e m i s i o n , c p . c o n c e p t o , 
 c p . c l i e n t e e n v i a r a , c p . v e n c i m i e n t o , c p . i m p o r t e ,   c p . i m p u e s t o s , c p . s a l d o , c p . r e f e r e n c i a 
 f r o m   c x c p e n d i e n t e   c p   j o i n   n e c i a m o r a t o r i o s m a v i   n m m   o n ( c p . m o v   =   n m m . m o v   a n d   c p . m o v i d   =   n m m . m o v i d ) 
 w h e r e   c p . p a d r e m a v i   =   @ o r i g e n   a n d   c p . p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   c p . e s t a t u s =   ' p e n d i e n t e ' 
 a n d   ( n m m . m o v   l i k e   ' % n o t a   c a r % '   o r   n m m . m o v   l i k e   ' % c o n t r a   r e c i b o % ' ) 
 a n d   n m m . i d c o b r o = @ i d c o b r o ) x   ) 
 e n d 
 i f   @ a p l i c a a   < >   ' i m p o r t e   d e   f a c t u r a '   a n d   @ b o n i f i c a c i o n < > ' b o n i f i c a c i o n   p a   p u n t u a l ' 
 s e l e c t   @ m o n t o b o n i f   =   ( @ p o r c b o n 1 / 1 0 0 )   *   @ i m p o r t e v e n t a 2 
 i f   @ a p l i c a a   < >   ' i m p o r t e   d e   f a c t u r a '   a n d   @ b o n i f i c a c i o n = ' b o n i f i c a c i o n   p a   p u n t u a l ' 
 s e l e c t   @ m o n t o b o n i f   =   ( @ p o r c b o n 1 / 1 0 0 )   *   @ i m p o r t e d o c t o 
 i f   n o t   @ o k   i s   n u l l   s e l e c t   @ m o n t o b o n i f   =   0 . 0 0 , @ p o r c b o n 1   =   0 . 0 0 
 i f   @ b o n i f i c a c i o n   l i k e   ' % p u n t u a l % '   a n d   ( d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   >   ( d b o . f n f e c h a s i n h o r a ( @ v e n c i m i e n t o ) ) ) 
 b e g i n 
 i f   (   s e l e c t   d v   =   d a t e d i f f ( d d , @ v e n c i m i e n t o ,   c o n v e r t ( d a t e t i m e , c o n v e r t ( v a r c h a r ( 1 0 ) , g e t d a t e ( ) , 1 0 ) ) )   )   < =   @ d v e x t r a 
 s e l e c t   @ p o r c b o n 1   =   @ p o r c b o n e x t r a ,   @ m o n t o b o n i f   =   ( @ p o r c b o n e x t r a / 1 0 0 )   *   @ i m p o r t e d o c t o 
 e l s e 
 s e l e c t   @ o k   =   1   ,   @ o k r e f   =   ' e x c e d e   e l   v e n c i m i e n t o ' ,   @ m o n t o b o n i f   =   0 . 0 0   ,   @ p o r c b o n 1   =   0 . 0 0 
 e n d 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) )   > =   d b o . f n f e c h a s i n h o r a ( @ v e n c i m i e n t o ) 
 s e l e c t   @ m o n t o b o n i f   =   0 . 0 0   ,   @ p o r c b o n 1   =   0 . 0 0 ,   @ o k   =   1   ,   @ o k r e f   =   ' p o r   e l   v e n c i m i e n t o   d e l   d o c t o ' 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   a n d   @ t i p o < > ' t o t a l '   s e l e c t   @ m o n t o b o n i f   =   0 . 0 0   ,   @ p o r c b o n 1   =   0 . 0 0   ,   @ o k   =   1   ,   @ o k r e f   =   ' a d e l a n t o   a p l i c a   a   p u r o   t o t a l ' 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a t r a s o % '   a n d   @ t i p o < > ' t o t a l '   s e l e c t   @ m o n t o b o n i f   =   0 . 0 0   ,   @ p o r c b o n 1   =   0 . 0 0 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a t r a s o % '   a n d   @ t i p o < > ' t o t a l '   s e l e c t   @ b a s e p a r a a p l i c a r   =   @ b a s e p a r a a p l i c a r   -   @ m o n t o b o n i f p a p a 
 i f   @ b o n i f i c a c i o n   l i k e   ' % a t r a s o % '   s e l e c t   @ b a s e p a r a a p l i c a r   =   @ i m p o r t e v e n t a 2 
 i f   @ b o n i f i c a c i o n   l i k e   ' % p u n t u a l % '   s e l e c t   @ b a s e p a r a a p l i c a r   =   @ i m p o r t e d o c t o 
 i n s e r t   m a v i b o n i f i c a c i o n t e s t   ( i d b o n i f i c a c i o n ,   i d c o b r o ,   d o c t o , b o n i f i c a c i o n ,   e s t a c i o n ,   d o c u m e n t o 1 d e , d o c u m e n t o t o t a l , m o v ,   m o v i d , o r i g e n , o r i g e n i d , i m p o r t e v e n t a , i m p o r t e d o c t o ,   m o n t o b o n i f ,   t i p o s u c u r s a l , l i n e a v t a , i d v e n t a , u e n , c o n d i c i o n , p o r c b o n 1 , 
 f i n a n c i a m i e n t o ,   o k , o k r e f , f a c t o r , s u c u r s a l 1 ,   p l a z o e j e f i n , f e c h a e m i s i o n , v e n c i m i e n t o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s , d i a s m e n o r e s a , d i a s m a y o r e s a , b a s e p a r a a p l i c a r ) 
 v a l u e s ( @ i d b o n i f i c a c i o n , @ i d c o b r o ,   @ i d c x c , i s n u l l ( @ b o n i f i c a c i o n , ' ' ) , @ e s t a c i o n ,   i s n u l l ( @ d o c u m e n t o 1 d e , 0 ) , i s n u l l ( @ d o c u m e n t o t o t a l , 0 ) , i s n u l l ( @ m o v , ' ' ) , i s n u l l ( @ m o v i d , ' ' ) ,   i s n u l l ( @ o r i g e n , ' ' ) , i s n u l l ( @ o r i g e n i d , ' ' ) , 
 r o u n d ( i s n u l l ( @ i m p o r t e v e n t a , 0 . 0 0 ) , 2 ) ,   r o u n d ( i s n u l l ( @ i m p o r t e d o c t o , 0 . 0 0 ) , 2 ) ,   r o u n d ( i s n u l l ( @ m o n t o b o n i f , 0 . 0 0 ) , 2 ) ,   i s n u l l ( @ t i p o s u c u r s a l , ' ' ) , i s n u l l ( @ l i n e a v t a , ' ' ) , i s n u l l ( @ i d v e n t a , 0 ) , i s n u l l ( @ u e n , 0 ) , i s n u l l ( @ c o n d i c i o n , ' ' ) , 
 i s n u l l ( @ p o r c b o n 1 , 0 . 0 0 ) ,   i s n u l l ( @ f i n a n c i a m i e n t o , 0 . 0 0 ) ,   i s n u l l ( @ o k , 0 ) , i s n u l l ( @ o k r e f , ' ' ) , i s n u l l ( @ f a c t o r , 0 . 0 0 ) , @ s u c u r s a l , @ p l a z o e j e f i n , @ f e c h a e m i s i o n , @ v e n c i m i e n t o ,   i s n u l l ( @ l i n e a c e l u l a r e s , 0 . 0 0 ) ,   i s n u l l ( @ l i n e a c r e d i l a n a s , 0 . 0 0 ) , 
 @ d i a s m e n o r e s a , @ d i a s m a y o r e s a , r o u n d ( i s n u l l ( @ b a s e p a r a a p l i c a r , 0 . 0 0 ) , 2 ) ) 
 e n d 
 s e t   @ r e c o r r e   =   @ r e c o r r e   +   1 
 e n d 
 e n d 
 i f   e x i s t s ( s e l e c t   *   f r o m   t e m p d b . s y s . s y s o b j e c t s   w h e r e   i d = o b j e c t _ i d ( ' t e m p d b . . # m o v s p e n d i e n t e s ' )   a n d   t y p e = ' u ' ) 
 d r o p   t a b l e   # m o v s p e n d i e n t e s 
 i f   e x i s t s ( s e l e c t   *   f r o m   t e m p d b . s y s . s y s o b j e c t s   w h e r e   i d = o b j e c t _ i d ( ' t e m p d b . d b o . # c r c x c p e n d i e n t e s ' )   a n d   t y p e   = ' u ' ) 
 d r o p   t a b l e   # c r c x c p e n d i e n t e s 
 e n d 