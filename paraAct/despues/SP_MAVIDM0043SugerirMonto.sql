u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p _ m a v i d m 0 0 4 3 s u g e r i r m o n t o ] 
 @ i d f a c   i n t   , @ e s t a c i o n   i n t   ,   @ i d c o b r o   i n t   ,   @ i m p o r t e t o t a l   m o n e y 
 a s 
 b e g i n 
 s e t   a r i t h a b o r t   o n ; 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # f a c t u r a ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # f a c t u r a 
 c r e a t e   t a b l e   # f a c t u r a   ( 
 i d f a c t   i n t , 
 p a d r e m a v i   v a r c h a r ( 5 0 ) , 
 p a d r e i d m a v i   v a r c h a r ( 5 0 ) , 
 f e c h a e m i s i o n f a c t   d a t e t i m e , 
 m a x d i a s a t r a z o   i n t , 
 i m p o r t e f a c t   m o n e y , 
 c o n d i c i o n   v a r c h a r ( 1 0 0 )   n u l l , 
 n u m d o c s   i n t , 
 m o n e d e r o   m o n e y , 
 c o b x p o l   v a r c h a r ( 5 ) , 
 u e n   i n t   n u l l , 
 s u c u r s a l   i n t 
 ) 
 i n s e r t   i n t o   # f a c t u r a 
 s e l e c t 
 a . i d   i d f a c t , 
 a . p a d r e m a v i , 
 a . p a d r e i d m a v i , 
 f e c h a e m i s i o n f a c t   =   a . f e c h a e m i s i o n , 
 m a x d i a s a t r a z o   =   i s n u l l ( c m . m a x d i a s v e n c i d o s m a v i ,   0 ) , 
 a . i m p o r t e   +   a . i m p u e s t o s   i m p o r t e f a c t , 
 a . c o n d i c i o n , 
 i s n u l l ( d a n u m e r o d o c u m e n t o s ,   0 )   n u m d o c s , 
 0 . 0 0   m o n e d e r o , 
 ' ' , 
 u e n , 
 s u c u r s a l 
 f r o m   ( s e l e c t 
 i d , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 f e c h a e m i s i o n , 
 i s n u l l ( c o n d i c i o n ,   ' ' )   c o n d i c i o n , 
 i m p o r t e , 
 i m p u e s t o s , 
 i s n u l l ( u e n ,   ' ' )   u e n , 
 s u c u r s a l 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d f a c )   a 
 l e f t   j o i n   c o n d i c i o n   c n   w i t h   ( n o l o c k ) 
 o n   c n . c o n d i c i o n   =   a . c o n d i c i o n 
 l e f t   j o i n   c x c m a v i   c m   w i t h   ( n o l o c k ) 
 o n   a . i d   =   c m . i d 
 i f   ( s e l e c t 
 i s n u l l ( v a l o r ,   ' ' ) 
 f r o m   t a b l a s t d   w i t h   ( n o l o c k ) 
 w h e r e   t a b l a s t   =   ' c a l c u l a   b o n i f   e n   c o b r o ' 
 a n d   n o m b r e   =   ' a c t i v a r ' ) 
 =   ' 1 ' 
 b e g i n 
 i f   ( s e l e c t 
 c o u n t ( i d ) 
 f r o m   # f a c t u r a   f 
 j o i n   c x c   d o c s   w i t h   ( n o l o c k ) 
 o n   d o c s . p a d r e m a v i   =   f . p a d r e m a v i 
 a n d   d o c s . p a d r e i d m a v i   =   f . p a d r e i d m a v i 
 w h e r e   d o c s . e s t a t u s   i n   ( ' p e n d i e n t e ' ,   ' c o n c l u i d o ' ) 
 a n d   d o c s . i d   ! =   f . i d f a c t 
 a n d   d o c s . i d b o n i f a p   i s   n u l l 
 a n d   d o c s . i d b o n i f c c   i s   n u l l 
 a n d   d o c s . i d b o n i f p p   i s   n u l l ) 
 >   0 
 b e g i n 
 d e c l a r e   @ m o v   v a r c h a r ( 3 0 ) , 
 @ m o v i d   v a r c h a r ( 3 0 ) 
 s e l e c t 
 @ m o v   =   p a d r e m a v i , 
 @ m o v i d   =   p a d r e i d m a v i 
 f r o m   # f a c t u r a 
 e x e c   s p _ m a v i d m 0 2 7 9 c a l c u l a r b o n i f   @ m o v , 
 @ m o v i d , 
 n u l l , 
 n u l l , 
 @ c l a v e   =   ' c o b r o ' 
 e n d 
 e n d 
 d e l e t e   m 
 f r o m   m a v i b o n i f i c a c i o n t e s t   m   j o i n   # f a c t u r a   f 
 o n   o r i g e n i d   =   p a d r e i d m a v i 
 a n d   o r i g e n   =   p a d r e m a v i 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # d o c s ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # d o c s 
 s e l e c t 
 d o c s . c l i e n t e , 
 d o c s . i d , 
 d o c s . m o v , 
 d o c s . m o v i d , 
 d o c s . p a d r e m a v i , 
 d o c s . p a d r e i d m a v i , 
 i m p o r t e   +   i m p u e s t o s   i m p o r t e d o c , 
 s a l d o , 
 d o c s . v e n c i m i e n t o , 
 i s n u l l ( d o c s . i d b o n i f a p ,   0 )   i d b o n i f a p , 
 i s n u l l ( d o c s . i d b o n i f c c ,   0 )   i d b o n i f c c , 
 i s n u l l ( d o c s . b o n i f c c ,   0 )   b o n i f c c , 
 i s n u l l ( d o c s . i d b o n i f p p ,   0 )   i d b o n i f p p , 
 i s n u l l ( d o c s . b o n i f p p ,   0 )   b o n i f p p , 
 i s n u l l ( d o c s . b o n i f p p e x t ,   0 )   b o n i f p p e x t , 
 d o c s . e s t a t u s , 
 d o c s . c o n c e p t o , 
 d v n   =   d a t e d i f f ( d d ,   v e n c i m i e n t o ,   c o n v e r t ( d a t e t i m e ,   c o n v e r t ( v a r c h a r ( 1 0 ) ,   g e t d a t e ( ) ,   1 0 ) ) ) , 
 d o c s . f e c h a e m i s i o n , 
 d o c s . c o n d i c i o n , 
 c a s e 
 w h e n   i s n u l l ( r e f e r e n c i a m a v i ,   r e f e r e n c i a )   l i k e   ' % / % '   t h e n   s u b s t r i n g ( i s n u l l ( r e f e r e n c i a m a v i ,   r e f e r e n c i a ) ,   1 ,   c h a r i n d e x ( ' / ' ,   i s n u l l ( r e f e r e n c i a m a v i ,   r e f e r e n c i a ) )   -   1 ) 
 e n d   r e f e r e n c i a , 
 c a s t ( 0 . 0 0   a s   f l o a t )   m o r a t o r i o s   i n t o   # d o c s 
 f r o m   # f a c t u r a   f 
 j o i n   c x c   d o c s   w i t h   ( n o l o c k ) 
 o n   d o c s . p a d r e m a v i   =   f . p a d r e m a v i 
 a n d   d o c s . p a d r e i d m a v i   =   f . p a d r e i d m a v i 
 w h e r e   d o c s . e s t a t u s   i n   ( ' p e n d i e n t e ' ,   ' c o n c l u i d o ' ) 
 a n d   d o c s . i d   ! =   f . i d f a c t 
 u p d a t e   f 
 s e t   m o n e d e r o   =   i s n u l l ( m o n . a b o n o ,   0 . 0 0 ) 
 f r o m   # f a c t u r a   f 
 j o i n   a u x i l i a r p   m o n   w i t h   ( n o l o c k ) 
 o n   m o n . m o v   =   f . p a d r e m a v i 
 a n d   m o n . m o v i d   =   f . p a d r e i d m a v i 
 u p d a t e   f 
 s e t   c o b x p o l   =   d b o . f n _ m a v i r m 0 9 0 6 c o b x p o l ( f . i d f a c t ) 
 f r o m   # f a c t u r a   f 
 u p d a t e   d c s 
 s e t   m o r a t o r i o s   =   d b o . f n i n t e r e s m o r a t o r i o m a v i ( d c s . i d ) 
 f r o m   # d o c s   d c s 
 l e f t   j o i n   # f a c t u r a   f 
 o n   f . p a d r e m a v i   =   d c s . p a d r e m a v i 
 a n d   f . p a d r e i d m a v i   =   d c s . p a d r e i d m a v i 
 w h e r e   d c s . e s t a t u s   =   ' p e n d i e n t e ' 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # b o n i f a p l i c a ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # b o n i f a p l i c a 
 s e l e c t 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i d , 
 a p l i c a a , 
 b o n i f i c a c i o n , 
 p o r c b o n 1 , 
 b o n i f _ e x t , 
 m a x d v p p e x t , 
 v e n c i m i e n t o a n t e s , 
 v e n c i m i e n t o d e s p , 
 d i a s a t r a z o , 
 d i a s m e n o r e s a , 
 d i a s m a y o r e s a , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n   i n t o   # b o n i f a p l i c a 
 f r o m   ( 
 s e l e c t 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 b . i d , 
 b . a p l i c a a , 
 b . b o n i f i c a c i o n , 
 b . v e n c i m i e n t o a n t e s , 
 b . v e n c i m i e n t o d e s p , 
 b . d i a s a t r a z o , 
 b . d i a s m e n o r e s a , 
 b . d i a s m a y o r e s a , 
 b . f i n a n c i a m i e n t o , 
 b . f a c t o r , 
 b . p l a z o e j e f i n , 
 c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   t h e n   c a s e 
 w h e n   m a x d i a s a t r a z o   >   b . d i a s a t r a z o   a n d 
 b . d i a s a t r a z o   < >   0   t h e n   ' n o   a p l i c a ' 
 w h e n   b . v e n c i m i e n t o a n t e s   < >   0   a n d 
 d . v e n c y a p a s o   > =   b . v e n c i m i e n t o a n t e s   t h e n   ' n o   a p l i c a ' 
 w h e n   b . d i a s m e n o r e s a   < >   0   a n d 
 b . d i a s m e n o r e s a   <   d a t e d i f f ( d a y ,   f e c h a e m i s i o n f a c t ,   g e t d a t e ( ) )   t h e n   ' n o   a p l i c a ' 
 w h e n   d i a s m a y o r e s a   < >   0   a n d 
 d i a s m a y o r e s a   > =   d a t e d i f f ( d d ,   f e c h a e m i s i o n f a c t ,   p r i m e r v e n c )   t h e n   ' n o   a p l i c a ' 
 e l s e   ' a p l i c a ' 
 e n d 
 e n d   b o n i f c c , 
 c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % a d e l a n t o   e n   p a s % '   t h e n   c a s e 
 w h e n   b . v e n c i m i e n t o a n t e s   < >   0   a n d 
 d . v e n c y a p a s o   > =   b . v e n c i m i e n t o a n t e s   t h e n   ' n o   a p l i c a ' 
 w h e n   b . v e n c i m i e n t o d e s p   < >   0   a n d 
 d . v e n c y a p a s o   <   b . v e n c i m i e n t o d e s p   t h e n   ' n o   a p l i c a ' 
 w h e n   b . d i a s m a y o r e s a   < >   0   a n d 
 b . d i a s m a y o r e s a   >   d . v e n c y a p a s o   t h e n   ' n o   a p l i c a ' 
 w h e n   b . d i a s m e n o r e s a   < >   0   a n d 
 b . d i a s m e n o r e s a   <   d . v e n c y a p a s o   t h e n   ' n o   a p l i c a ' 
 e l s e   ' a p l i c a ' 
 e n d 
 e n d   b o n i f a p , 
 c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % '   a n d 
 d . i d b o n i f p p   i s   n o t   n u l l   t h e n   ' a p l i c a ' 
 e l s e   ' ' 
 e n d   b o n i f p p , 
 c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % a d e l a n t o   e n   p a s % '   a n d 
 b . p o r c b o n 1   =   0   t h e n   b . l i n e a 
 e l s e   b . p o r c b o n 1 
 e n d   p o r c b o n 1 , 
 i s n u l l ( b c . p o r c b o n ,   0 )   b o n i f _ e x t , 
 i s n u l l ( b c . m a x d v ,   0 )   m a x d v p p e x t , 
 f e c h a e m i s i o n f a c t 
 f r o m   ( 
 s e l e c t 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i d b o n i f c c , 
 i d b o n i f p p , 
 i d b o n i f a p , 
 m i n ( v e n c i m i e n t o )   p r i m e r v e n c , 
 i s n u l l ( m a x ( c a s e 
 w h e n   v e n c y a p a s o   =   ' s '   t h e n   o r d e n v e n c 
 e n d ) ,   0 )   v e n c y a p a s o , 
 i s n u l l ( m a x ( c a s e 
 w h e n   v e n c y a p a s o   =   ' s '   t h e n   d v n 
 e n d ) ,   0 )   m a x d v n , 
 f e c h a e m i s i o n f a c t , 
 m a x d i a s a t r a z o 
 f r o m   ( 
 s e l e c t 
 d . p a d r e m a v i , 
 d . p a d r e i d m a v i , 
 i s n u l l ( d . i d b o n i f c c ,   0 )   i d b o n i f c c , 
 i s n u l l ( d . i d b o n i f p p ,   0 )   i d b o n i f p p , 
 i s n u l l ( d . i d b o n i f a p ,   0 )   i d b o n i f a p , 
 d . m o v , 
 d . m o v i d , 
 f . f e c h a e m i s i o n f a c t , 
 r o w _ n u m b e r ( )   o v e r   ( o r d e r   b y   d . v e n c i m i e n t o )   o r d e n v e n c , 
 d . d v n , 
 c a s e 
 w h e n   d . d v n   >   0   t h e n   ' s ' 
 e l s e   ' ' 
 e n d   v e n c y a p a s o , 
 d . v e n c i m i e n t o , 
 f . m a x d i a s a t r a z o 
 f r o m   # d o c s   d 
 l e f t   j o i n   # f a c t u r a   f 
 o n   f . p a d r e m a v i   =   d . p a d r e m a v i 
 a n d   f . p a d r e i d m a v i   =   d . p a d r e i d m a v i 
 w h e r e   d . m o v   =   ' d o c u m e n t o ' )   b 
 g r o u p   b y   p a d r e m a v i , 
 p a d r e i d m a v i , 
 i d b o n i f c c , 
 i d b o n i f p p , 
 i d b o n i f a p , 
 f e c h a e m i s i o n f a c t , 
 m a x d i a s a t r a z o )   d 
 l e f t   j o i n   m a v i b o n i f i c a c i o n c o n f   b   w i t h   ( n o l o c k ) 
 o n   b . i d   i n   ( d . i d b o n i f c c ,   d . i d b o n i f p p ,   d . i d b o n i f a p ) 
 l e f t   j o i n   m a v i b o n i f i c a c i o n c o n v e n c i m i e n t o   b c   w i t h   ( n o l o c k ) 
 o n   b c . i d b o n i f i c a c i o n   =   b . i d )   f 
 w h e r e   i s n u l l ( b o n i f c c ,   ' ' )   =   ' a p l i c a ' 
 o r   i s n u l l ( b o n i f p p ,   ' ' )   =   ' a p l i c a ' 
 o r   i s n u l l ( b o n i f a p ,   ' ' )   =   ' a p l i c a ' 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # b o n f i c a c i o n e s ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # b o n f i c a c i o n e s 
 s e l e c t 
 r . c l i e n t e , 
 r . i d , 
 i d b o n i f i c a c i o n , 
 r . b o n i f i c a c i o n , 
 @ e s t a c i o n   e s t a c i o n , 
 r . m o v , 
 r . m o v i d , 
 r . p a d r e m a v i , 
 r . p a d r e i d m a v i , 
 r o u n d ( f . i m p o r t e f a c t   -   f . m o n e d e r o ,   2 )   i m p o r t e f a c t f i n , 
 r o u n d ( ( f . i m p o r t e f a c t   -   f . m o n e d e r o )   /   ( f . n u m d o c s ) ,   2 )   i m p o r t e d o c , 
 r . p o r c b o n p p , 
 r . p o r c b o n c c , 
 c a s e 
 w h e n   r . b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   p a   p u n t u a l '   t h e n   b o n i f p p f i n a l 
 w h e n   r . b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l '   t h e n   b o n i f c c 
 e n d   m o n t o b o n i f , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 d o c u m e n t o 1 d e , 
 f . s u c u r s a l   s u c u r s a l 1 , 
 ' '   t i p o s u c u r s a l , 
 ' '   l i n e a v t a , 
 r . d i a s m e n o r e s a , 
 r . d i a s m a y o r e s a , 
 0   i d v e n t a , 
 f . u e n , 
 f . c o n d i c i o n , 
 ' '   o k , 
 ' '   o k r e f , 
 f . f e c h a e m i s i o n f a c t , 
 r . v e n c i m i e n t o , 
 @ i d c o b r o   i d c r o b o , 
 ' '   l i n e a c e l u l a r e s , 
 ' '   l i n e a c r e d i l a n a s , 
 f . i d f a c t , 
 0   b a s e p a r a a p l i c a r , 
 f . n u m d o c s , 
 f . m o n e d e r o , 
 c a s e 
 w h e n   r . b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l '   t h e n   ( ( f . n u m d o c s   -   r . p l a z o e j e f i n )   *   ( r . f i n a n c i a m i e n t o   /   1 0 0 )   +   1 ) 
 e l s e   0 
 e n d   f a c t o r c o n v e r s i o n _ c c   i n t o   # b o n f i c a c i o n e s 
 f r o m   ( s e l e c t 
 d . c l i e n t e , 
 d . i d , 
 b . i d   i d b o n i f i c a c i o n , 
 b . b o n i f i c a c i o n , 
 d . m o v , 
 d . m o v i d , 
 d . p a d r e m a v i , 
 d . p a d r e i d m a v i , 
 c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % '   a n d 
 d v n   < =   0   t h e n   b . p o r c b o n 1 
 e l s e   c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % '   a n d 
 d v n   < =   m a x d v p p e x t   t h e n   b . b o n i f _ e x t 
 e l s e   0 
 e n d 
 e n d   p o r c b o n p p , 
 c a s e 
 w h e n   b . b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % '   t h e n   b . p o r c b o n 1 
 e l s e   0 
 e n d   p o r c b o n c c , 
 c a s e 
 w h e n   d v n   < =   0   t h e n   d . b o n i f p p 
 e l s e   c a s e 
 w h e n   d v n   < =   m a x d v p p e x t   t h e n   d . b o n i f p p e x t 
 e l s e   0 
 e n d 
 e n d   b o n i f p p f i n a l , 
 d . b o n i f c c , 
 b . f a c t o r , 
 b . f i n a n c i a m i e n t o , 
 b . p l a z o e j e f i n , 
 c a s e 
 w h e n   r e f e r e n c i a   l i k e   ' % ( % '   t h e n   s u b s t r i n g ( r e f e r e n c i a ,   c h a r i n d e x ( ' ( ' ,   r e f e r e n c i a )   +   1 ,   5 ) 
 e l s e   ' ' 
 e n d   d o c u m e n t o 1 d e , 
 b . d i a s m e n o r e s a , 
 b . d i a s m a y o r e s a , 
 d . v e n c i m i e n t o 
 f r o m   # d o c s   d 
 j o i n   # b o n i f a p l i c a   b 
 o n   b . p a d r e m a v i   =   d . p a d r e m a v i 
 a n d   b . p a d r e i d m a v i   =   d . p a d r e i d m a v i 
 w h e r e   e s t a t u s   =   ' p e n d i e n t e ' )   r 
 l e f t   j o i n   # f a c t u r a   f 
 o n   f . p a d r e m a v i   =   r . p a d r e m a v i 
 a n d   f . p a d r e i d m a v i   =   r . p a d r e i d m a v i 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # t e m p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # t e m p 
 c r e a t e   t a b l e   # t e m p   ( 
 d o c t o   i n t   n u l l , 
 i d b o n i f i c a c i o n   i n t   n u l l , 
 b o n i f i c a c i o n   v a r c h a r ( 4 0 )   n u l l , 
 e s t a c i o n   i n t   n u l l , 
 m o v   v a r c h a r ( 5 0 )   n u l l , 
 m o v i d   v a r c h a r ( 5 0 )   n u l l , 
 p a d r e m a v i   v a r c h a r ( 5 0 )   n u l l , 
 p a d r e i d m a v i   v a r c h a r ( 5 0 )   n u l l , 
 i m p o r t e f a c t   m o n e y   n u l l , 
 i m p o r t e d o c   m o n e y   n u l l , 
 p o r c b o n   m o n e y   n u l l , 
 m o n t o b o n i f   m o n e y   n u l l , 
 f i n a n c i a m i e n t o   m o n e y   n u l l , 
 f a c t o r   m o n e y   n u l l , 
 p l a z o e j e f i n   i n t , 
 d o c u m e n t o 1 d e   i n t   n u l l , 
 d o c u m e n t o t o t a l   i n t   n u l l , 
 s u c u r s a l 1   i n t   n u l l , 
 t i p o s u c u r s a l   v a r c h a r ( 5 0 )   n u l l , 
 l i n e a v t a   v a r c h a r ( 1 0 0 )   n u l l , 
 d i a s m e n o r e s a   i n t   n u l l , 
 d i a s m a y o r e s a   i n t   n u l l , 
 i d v e n t a   i n t   n u l l , 
 u e n   i n t , 
 c o n d i c i o n   v a r c h a r ( 1 0 0 )   n u l l , 
 o k   i n t   n u l l , 
 o k r e f   v a r c h a r ( 5 0 )   n u l l , 
 f e c h a e m i s i o n f a c t   d a t e t i m e , 
 v e n c i m i e n t o   d a t e t i m e , 
 i d c r o b o   i n t , 
 l i n e a c e l u l a r e s   v a r c h a r ( 1 0 0 )   n u l l , 
 l i n e a c r e d i l a n a s   v a r c h a r ( 1 0 0 )   n u l l , 
 b a s e p a r a a p l i c a r   m o n e y 
 ) 
 i n s e r t   i n t o   # t e m p   ( d o c t o ,   i d b o n i f i c a c i o n ,   b o n i f i c a c i o n ,   e s t a c i o n ,   m o v ,   m o v i d ,   p a d r e m a v i ,   p a d r e i d m a v i ,   i m p o r t e f a c t ,   i m p o r t e d o c 
 ,   p o r c b o n ,   m o n t o b o n i f ,   f i n a n c i a m i e n t o ,   f a c t o r ,   p l a z o e j e f i n ,   d o c u m e n t o 1 d e ,   d o c u m e n t o t o t a l ,   s u c u r s a l 1 ,   t i p o s u c u r s a l ,   l i n e a v t a ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   i d v e n t a 
 ,   u e n ,   c o n d i c i o n ,   o k ,   o k r e f ,   f e c h a e m i s i o n f a c t ,   v e n c i m i e n t o ,   i d c r o b o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s ,   b a s e p a r a a p l i c a r ) 
 s e l e c t 
 b . i d f a c t , 
 b . i d b o n i f i c a c i o n , 
 b . b o n i f i c a c i o n , 
 b . e s t a c i o n , 
 b . p a d r e m a v i   m o v , 
 b . p a d r e i d m a v i   m o v i d , 
 b . p a d r e m a v i , 
 b . p a d r e i d m a v i , 
 b . i m p o r t e f a c t f i n , 
 b . i m p o r t e f a c t f i n   i m p o r t e d o c , 
 b . p o r c b o n c c , 
 b . m o n t o b o n i f   -   s u m ( i s n u l l ( d t . i m p o r t e ,   0 ) ) 
 m o n t o b o n i f , 
 b . f i n a n c i a m i e n t o , 
 b . f a c t o r c o n v e r s i o n _ c c , 
 b . p l a z o e j e f i n , 
 1   d o c u m e n t o 1 d e , 
 b . n u m d o c s   d o c u m e n t o t o t a l , 
 s u c u r s a l 1 , 
 ' '   t i p o s u c u r s a l , 
 ' '   l i n e a v t a , 
 b . d i a s m e n o r e s a , 
 b . d i a s m a y o r e s a , 
 b . i d v e n t a , 
 b . u e n , 
 b . c o n d i c i o n , 
 b . o k , 
 b . o k r e f , 
 b . f e c h a e m i s i o n f a c t , 
 b . v e n c i m i e n t o , 
 b . i d c r o b o , 
 b . l i n e a c e l u l a r e s , 
 b . l i n e a c r e d i l a n a s , 
 b . b a s e p a r a a p l i c a r 
 f r o m   ( s e l e c t 
 c l i e n t e , 
 i d f a c t , 
 i d b o n i f i c a c i o n , 
 b o n i f i c a c i o n , 
 e s t a c i o n , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i m p o r t e f a c t f i n , 
 p o r c b o n c c , 
 c o u n t ( i d )   t o t p e n d i e n t e s , 
 n u m d o c s   *   m a x ( m o n t o b o n i f )   m o n t o b o n i f , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 d i a s m e n o r e s a , 
 d i a s m a y o r e s a , 
 i d v e n t a , 
 u e n , 
 c o n d i c i o n , 
 o k , 
 o k r e f , 
 f e c h a e m i s i o n f a c t , 
 m i n ( v e n c i m i e n t o )   v e n c i m i e n t o , 
 i d c r o b o , 
 l i n e a c e l u l a r e s , 
 l i n e a c r e d i l a n a s , 
 b a s e p a r a a p l i c a r , 
 n u m d o c s , 
 f a c t o r c o n v e r s i o n _ c c , 
 s u c u r s a l 1 
 f r o m   # b o n f i c a c i o n e s 
 w h e r e   i s n u l l ( b o n i f i c a c i o n ,   ' ' )   =   ' b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l ' 
 g r o u p   b y   c l i e n t e , 
 i d f a c t , 
 i d b o n i f i c a c i o n , 
 b o n i f i c a c i o n , 
 e s t a c i o n , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i m p o r t e f a c t f i n , 
 p o r c b o n c c , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 d i a s m e n o r e s a , 
 d i a s m a y o r e s a , 
 i d v e n t a , 
 u e n , 
 c o n d i c i o n , 
 o k , 
 o k r e f , 
 f e c h a e m i s i o n f a c t , 
 i d c r o b o , 
 l i n e a c e l u l a r e s , 
 l i n e a c r e d i l a n a s , 
 b a s e p a r a a p l i c a r , 
 n u m d o c s , 
 f a c t o r c o n v e r s i o n _ c c , 
 u e n , 
 s u c u r s a l 1 )   b 
 l e f t   j o i n   c x c   n c   w i t h   ( n o l o c k ) 
 o n   n c . c l i e n t e   =   b . c l i e n t e 
 a n d   n c . m o v   l i k e   ' n o t a   c r e d i t o % ' 
 a n d   n c . c o n c e p t o   l i k e   ' % p a   p u n t u a l % ' 
 a n d   n c . e s t a t u s   =   ' c o n c l u i d o ' 
 l e f t   j o i n   # d o c s   d 
 o n   b . p a d r e m a v i   =   d . p a d r e m a v i 
 a n d   b . p a d r e i d m a v i   =   d . p a d r e i d m a v i 
 a n d   d . e s t a t u s   =   ' c o n c l u i d o ' 
 l e f t   j o i n   c x c d   d t   w i t h   ( n o l o c k ) 
 o n   n c . i d   =   d t . i d 
 a n d   d t . a p l i c a   =   d . m o v 
 a n d   d t . a p l i c a i d   =   d . m o v i d 
 g r o u p   b y   b . i d f a c t , 
 b . i d b o n i f i c a c i o n , 
 b . b o n i f i c a c i o n , 
 b . e s t a c i o n , 
 b . p a d r e m a v i , 
 b . p a d r e i d m a v i , 
 b . i m p o r t e f a c t f i n , 
 b . p o r c b o n c c , 
 b . m o n t o b o n i f , 
 b . f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 n u m d o c s , 
 b . d i a s m e n o r e s a , 
 b . d i a s m a y o r e s a , 
 b . i d v e n t a , 
 b . u e n , 
 b . c o n d i c i o n , 
 b . o k , 
 b . o k r e f , 
 b . f e c h a e m i s i o n f a c t , 
 b . v e n c i m i e n t o , 
 b . i d c r o b o , 
 b . l i n e a c e l u l a r e s , 
 b . l i n e a c r e d i l a n a s , 
 b . b a s e p a r a a p l i c a r , 
 f a c t o r c o n v e r s i o n _ c c , 
 b . s u c u r s a l 1 
 i n s e r t   i n t o   # t e m p   ( d o c t o ,   i d b o n i f i c a c i o n ,   b o n i f i c a c i o n ,   e s t a c i o n ,   m o v ,   m o v i d ,   p a d r e m a v i ,   p a d r e i d m a v i ,   i m p o r t e f a c t ,   i m p o r t e d o c 
 ,   p o r c b o n ,   m o n t o b o n i f ,   f i n a n c i a m i e n t o ,   f a c t o r ,   p l a z o e j e f i n ,   d o c u m e n t o 1 d e ,   d o c u m e n t o t o t a l ,   s u c u r s a l 1 ,   t i p o s u c u r s a l ,   l i n e a v t a ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   i d v e n t a 
 ,   u e n ,   c o n d i c i o n ,   o k ,   o k r e f ,   f e c h a e m i s i o n f a c t ,   v e n c i m i e n t o ,   i d c r o b o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s ,   b a s e p a r a a p l i c a r ) 
 s e l e c t 
 b . i d , 
 b . i d b o n i f i c a c i o n , 
 b . b o n i f i c a c i o n , 
 b . e s t a c i o n , 
 b . m o v , 
 b . m o v i d , 
 b . p a d r e m a v i , 
 b . p a d r e i d m a v i , 
 b . i m p o r t e f a c t f i n , 
 r o u n d ( b . i m p o r t e d o c ,   2 )   i m p o r t e d o c , 
 b . p o r c b o n p p , 
 r o u n d ( b . m o n t o b o n i f ,   2 )   m o n t o b o n i f , 
 b . f i n a n c i a m i e n t o , 
 b . f a c t o r , 
 b . p l a z o e j e f i n , 
 b . d o c u m e n t o 1 d e , 
 b . n u m d o c s   d o c u m e n t o t o t a l , 
 b . s u c u r s a l 1 , 
 b . t i p o s u c u r s a l , 
 b . l i n e a v t a , 
 b . d i a s m e n o r e s a , 
 b . d i a s m a y o r e s a , 
 b . i d v e n t a , 
 b . u e n , 
 b . c o n d i c i o n , 
 b . o k , 
 b . o k r e f , 
 b . f e c h a e m i s i o n f a c t , 
 b . v e n c i m i e n t o , 
 b . i d c r o b o , 
 b . l i n e a c e l u l a r e s , 
 b . l i n e a c r e d i l a n a s , 
 b . b a s e p a r a a p l i c a r 
 f r o m   # b o n f i c a c i o n e s   b 
 w h e r e   b . b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   p a   p u n t u a l ' 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # b o n i f a p l i p p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # b o n i f a p l i p p 
 s e l e c t 
 d s . p a d r e m a v i , 
 d s . p a d r e i d m a v i , 
 s u m ( i s n u l l ( d t . i m p o r t e ,   0 ) )   b o n i f a p l i p p   i n t o   # b o n i f a p l i p p 
 f r o m   # d o c s   d s 
 j o i n   c x c d   d t   w i t h   ( n o l o c k ) 
 o n   d t . a p l i c a   =   d s . m o v 
 a n d   d t . a p l i c a i d   =   d s . m o v i d 
 j o i n   c x c   n c   w i t h   ( n o l o c k ) 
 o n   n c . i d   =   d t . i d 
 a n d   n c . m o v   l i k e   ' n o t a   c r e d i t o % ' 
 a n d   n c . c o n c e p t o   l i k e   ' % p a   p u n t u a l % ' 
 a n d   n c . e s t a t u s   =   ' c o n c l u i d o ' 
 w h e r e   d s . e s t a t u s   =   ' c o n c l u i d o ' 
 g r o u p   b y   d s . p a d r e m a v i , 
 d s . p a d r e i d m a v i 
 i f   e x i s t s   ( s e l e c t   t o p   1 
 i d 
 f r o m   # b o n i f a p l i c a 
 w h e r e   b o n i f i c a c i o n   n o t   i n   ( ' b o n i f i c a c i o n   p a   p u n t u a l ' ,   ' b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l ' ) ) 
 b e g i n 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # a r t c a n c ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # a r t c a n c 
 c r e a t e   t a b l e   # a r t c a n c   ( 
 p a d r e m a v i   v a r c h a r ( 5 0 ) , 
 p a d r e i d m a v i   v a r c h a r ( 5 0 ) , 
 a r t c a n c e l a d o   v a r c h a r ( 5 0 ) , 
 i m p o c a n c   m o n e y 
 ) 
 i n s e r t   i n t o   # a r t c a n c   ( p a d r e m a v i ,   p a d r e i d m a v i ,   a r t c a n c e l a d o ,   i m p o c a n c ) 
 s e l e c t 
 d . p a d r e m a v i , 
 d . p a d r e i d m a v i , 
 t . a r t i c u l o , 
 s u m ( t . c a n t i d a d   *   t . p r e c i o )   i m p o r t e a r t 
 f r o m   ( 
 s e l e c t 
 a . p a d r e m a v i , 
 a . p a d r e i d m a v i , 
 d v . i d 
 f r o m   ( 
 s e l e c t 
 f . p a d r e m a v i , 
 f . p a d r e i d m a v i , 
 s v . m o v , 
 s v . m o v i d 
 f r o m   # f a c t u r a   f 
 j o i n   v e n t a   s v   w i t h   ( n o l o c k ) 
 o n   s v . r e f e r e n c i a   =   f . p a d r e m a v i   +   '   '   +   f . p a d r e i d m a v i 
 )   a 
 j o i n   v e n t a   d v   w i t h   ( n o l o c k ) 
 o n   d v . o r i g e n   =   a . m o v 
 a n d   d v . o r i g e n i d   =   a . m o v i d 
 w h e r e   d v . m o v   l i k e   ' % d e v o l u c i o n % ' 
 a n d   d v . e s t a t u s   =   ' c o n c l u i d o ' )   d 
 j o i n   v e n t a d   t   w i t h   ( n o l o c k ) 
 o n   t . i d   =   d . i d 
 a n d   p r e c i o   >   0 
 g r o u p   b y   d . p a d r e m a v i , 
 d . p a d r e i d m a v i , 
 t . a r t i c u l o 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # d e t a l l e ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # d e t a l l e 
 s e l e c t 
 a r . p a d r e m a v i , 
 a r . p a d r e i d m a v i , 
 a r . a r t i c u l o , 
 a r . i m p o a r t   -   i s n u l l ( a c . i m p o c a n c ,   0 . 0 0 )   i m p o a r t , 
 a r . l i n e a   i n t o   # d e t a l l e 
 f r o m   ( s e l e c t 
 b . p a d r e m a v i , 
 b . p a d r e i d m a v i , 
 c a s e 
 w h e n   p a d r e m a v i   ! =   ' r e f i n a n c i a m i e n t o '   t h e n   v d . a r t i c u l o 
 e l s e   ' r e f i n a n c i a m i e n t o ' 
 e n d   a r t i c u l o , 
 c a s e 
 w h e n   p a d r e m a v i   ! =   ' r e f i n a n c i a m i e n t o '   t h e n   ( v d . p r e c i o   *   c a n t i d a d ) 
 e l s e   b . i m p o r t e f a c t 
 e n d   i m p o a r t , 
 a . l i n e a 
 f r o m   # f a c t u r a   b 
 l e f t   j o i n   v e n t a   v   w i t h   ( n o l o c k ) 
 o n   v . m o v   =   b . p a d r e m a v i 
 a n d   v . m o v i d   =   b . p a d r e i d m a v i 
 a n d   v . e s t a t u s   =   ' c o n c l u i d o ' 
 l e f t   j o i n   v e n t a d   v d   w i t h   ( n o l o c k ) 
 o n   v d . i d   =   v . i d 
 l e f t   j o i n   a r t   a   w i t h   ( n o l o c k ) 
 o n   a . a r t i c u l o   =   v d . a r t i c u l o )   a r 
 l e f t   j o i n   # a r t c a n c   a c 
 o n   a c . p a d r e m a v i   =   a r . p a d r e m a v i 
 a n d   a c . p a d r e i d m a v i   =   a r . p a d r e i d m a v i 
 a n d   a c . a r t c a n c e l a d o   =   a r . a r t i c u l o 
 i f   e x i s t s   ( s e l e c t   t o p   1 
 i d 
 f r o m   # b o n i f a p l i c a 
 w h e r e   b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   a d e l a n t o   e n   p a s ' ) 
 b e g i n 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # o t r o s d a t o s ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # o t r o s d a t o s 
 s e l e c t 
 d . * , 
 b c . m o n t o b o n i f   b o n c c , 
 i s n u l l ( b o n i f a p l i p p ,   0 . 0 0 )   b o n i f a p l i p p   i n t o   # o t r o s d a t o s 
 f r o m   ( s e l e c t 
 d . p a d r e m a v i , 
 d . p a d r e i d m a v i , 
 s u m ( s a l d o )   t o t s a l d o , 
 s u m ( m o r a t o r i o s )   t o t m o r a t o r i o s , 
 s u m ( i s n u l l ( m o n t o b o n i f ,   0 ) )   b o n p p 
 f r o m   # d o c s   d 
 l e f t   j o i n   # t e m p   b 
 o n   d . m o v   =   b . m o v 
 a n d   d . m o v i d   =   b . m o v i d 
 a n d   b . b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % ' 
 g r o u p   b y   d . p a d r e m a v i , 
 d . p a d r e i d m a v i )   d 
 l e f t   j o i n   # t e m p   b c 
 o n   d . p a d r e m a v i   =   b c . m o v 
 a n d   d . p a d r e i d m a v i   =   b c . m o v i d 
 a n d   b c . b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 l e f t   j o i n   # b o n i f a p l i p p   p p a 
 o n   p p a . p a d r e m a v i   =   d . p a d r e m a v i 
 a n d   p p a . p a d r e i d m a v i   =   d . p a d r e i d m a v i 
 i n s e r t   i n t o   # t e m p   ( d o c t o ,   i d b o n i f i c a c i o n ,   b o n i f i c a c i o n ,   e s t a c i o n ,   m o v ,   m o v i d ,   p a d r e m a v i ,   p a d r e i d m a v i ,   i m p o r t e f a c t ,   i m p o r t e d o c 
 ,   p o r c b o n ,   m o n t o b o n i f ,   f i n a n c i a m i e n t o ,   f a c t o r ,   p l a z o e j e f i n ,   d o c u m e n t o 1 d e ,   d o c u m e n t o t o t a l ,   s u c u r s a l 1 ,   t i p o s u c u r s a l ,   l i n e a v t a ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   i d v e n t a 
 ,   u e n ,   c o n d i c i o n ,   o k ,   o k r e f ,   f e c h a e m i s i o n f a c t ,   v e n c i m i e n t o ,   i d c r o b o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s ,   b a s e p a r a a p l i c a r ) 
 s e l e c t 
 d c . i d   d o c t o , 
 b . i d b o n i f , 
 b . b o n i f i c a c i o n , 
 d c . e s t a c i o n , 
 d c . m o v , 
 d c . m o v i d , 
 d c . p a d r e m a v i , 
 d c . p a d r e i d m a v i , 
 d c . i m p o r t e f a c t f i n , 
 d c . i m p o r t e f a c t f i n   /   b . n u m d o c s   i m p o r t e d o c , 
 c a s e 
 w h e n   d c . v e n c i m i e n t o   >   c o n v e r t ( d a t e t i m e ,   c o n v e r t ( v a r c h a r ( 1 0 ) ,   g e t d a t e ( ) ,   1 0 ) )   t h e n   b . p o r c d e s c t o 
 e l s e   0 . 0 0 
 e n d   p o r c d e s c t o , 
 c a s e 
 w h e n   d c . v e n c i m i e n t o   >   c o n v e r t ( d a t e t i m e ,   c o n v e r t ( v a r c h a r ( 1 0 ) ,   g e t d a t e ( ) ,   1 0 ) )   t h e n   b . b o n i f a p 
 e l s e   0 . 0 0 
 e n d   b o n i f a p , 
 d c . f i n a n c i a m i e n t o , 
 d c . f a c t o r , 
 d c . p l a z o e j e f i n , 
 d c . d o c u m e n t o 1 d e , 
 b . n u m d o c s , 
 d c . s u c u r s a l 1 , 
 d c . t i p o s u c u r s a l , 
 d c . l i n e a v t a , 
 d c . d i a s m e n o r e s a , 
 d c . d i a s m a y o r e s a , 
 d c . i d v e n t a , 
 d c . u e n , 
 d c . c o n d i c i o n , 
 d c . o k , 
 d c . o k r e f , 
 d c . f e c h a e m i s i o n f a c t , 
 d c . v e n c i m i e n t o , 
 d c . i d c r o b o , 
 d c . l i n e a c e l u l a r e s , 
 d c . l i n e a c r e d i l a n a s , 
 0   b a s e p a r a a p l i c a r 
 f r o m   ( 
 s e l e c t 
 i d b o n i f , 
 b o n i f i c a c i o n , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 c a s e 
 w h e n   ( t o t s a l d o   -   b o n i f a p c c )   < =   @ i m p o r t e t o t a l   t h e n   r o u n d ( b o n i f a p c c   /   n u m d o c s p e n d ,   2 ) 
 e l s e   r o u n d ( b o n i f a p p p   /   n u m d o c s p e n d ,   2 ) 
 e n d   b o n i f a p , 
 n u m d o c s , 
 p o r c d e s c t o , 
 t o t s a l d o 
 f r o m   ( 
 s e l e c t 
 f . i d b o n i f , 
 f . b o n i f i c a c i o n , 
 f . p a d r e m a v i , 
 f . p a d r e i d m a v i , 
 r o u n d ( s u m ( i m p o r t e _ a p c c   *   ( p o r c d e s c t o   /   1 0 0 ) ) ,   2 )   b o n i f a p c c , 
 r o u n d ( s u m ( i m p o r t e _ a p p p   *   ( p o r c d e s c t o   /   1 0 0 ) ) ,   2 )   b o n i f a p p p , 
 f . n u m d o c s , 
 p o r c d e s c t o , 
 t o t s a l d o , 
 f . n u m d o c s p e n d 
 f r o m   ( 
 s e l e c t 
 b f . * , 
 ( ( v d . i m p o a r t   -   o t r a s b o n i f c c x a r t   -   ( f . m o n e d e r o   *   ( v d . i m p o a r t   /   f . i m p o r t e f a c t ) ) )   /   f . n u m d o c s )   *   n u m d o c s a d e l   i m p o r t e _ a p c c , 
 ( ( v d . i m p o a r t   -   o t r a s b o n i f p p x a r t   -   ( f . m o n e d e r o   *   ( v d . i m p o a r t   /   f . i m p o r t e f a c t ) ) )   /   f . n u m d o c s )   *   n u m d o c s a d e l   i m p o r t e _ a p p p , 
 p o r c d e s c t o   =   n u m d o c s a d e l   *   c a s e 
 w h e n   i s n u l l ( m l . p o r c l i n ,   0 )   >   0   t h e n   m l . p o r c l i n 
 e l s e   p o r c b o n 1 
 e n d , 
 v d . a r t i c u l o , 
 v d . i m p o a r t , 
 f . i m p o r t e f a c t , 
 f . n u m d o c s 
 f r o m   ( 
 s e l e c t 
 a . * , 
 s u m ( c a s e 
 w h e n   d . m o v   =   ' d o c u m e n t o '   a n d 
 d . v e n c i m i e n t o   >   c o n v e r t ( d a t e t i m e ,   c o n v e r t ( v a r c h a r ( 1 0 ) ,   g e t d a t e ( ) ,   1 0 ) )   t h e n   1 
 e l s e   0 
 e n d )   n u m d o c s a d e l , 
 s u m ( c a s e 
 w h e n   e s t a t u s   =   ' p e n d i e n t e '   t h e n   1 
 e l s e   0 
 e n d )   n u m d o c s p e n d , 
 o t r a s b o n i f p p   /   a . t o t a r t   o t r a s b o n i f p p x a r t , 
 o t r a s b o n i f c c   /   a . t o t a r t   o t r a s b o n i f c c x a r t 
 f r o m   ( 
 s e l e c t 
 b . i d b o n i f , 
 b . b o n i f i c a c i o n , 
 b . p a d r e m a v i , 
 b . p a d r e i d m a v i , 
 b a . b o n p p   +   b a . b o n i f a p l i p p   o t r a s b o n i f p p , 
 b a . b o n c c   +   b a . b o n i f a p l i p p   o t r a s b o n i f c c , 
 b a . t o t s a l d o , 
 b . f a c t o r , 
 b . t o t a r t , 
 b . p o r c b o n 1 
 f r o m   ( 
 s e l e c t 
 b n . i d   i d b o n i f , 
 b n . b o n i f i c a c i o n , 
 b n . p a d r e m a v i , 
 b n . p a d r e i d m a v i , 
 b n . f a c t o r , 
 c o u n t ( d . a r t i c u l o )   t o t a r t , 
 b n . p o r c b o n 1 
 f r o m   # b o n i f a p l i c a   b n 
 l e f t   j o i n   # d e t a l l e   d 
 o n   d . p a d r e m a v i   =   b n . p a d r e m a v i 
 a n d   d . p a d r e i d m a v i   =   b n . p a d r e i d m a v i 
 w h e r e   b n . b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   a d e l a n t o   e n   p a s ' 
 g r o u p   b y   b n . p a d r e m a v i , 
 b n . b o n i f i c a c i o n , 
 b n . p a d r e i d m a v i , 
 b n . f a c t o r , 
 b n . i d , 
 b n . p o r c b o n 1 )   b 
 l e f t   j o i n   # o t r o s d a t o s   b a 
 o n   b a . p a d r e m a v i   =   b . p a d r e m a v i 
 a n d   b a . p a d r e i d m a v i   =   b . p a d r e i d m a v i 
 g r o u p   b y   b . i d b o n i f , 
 b . b o n i f i c a c i o n , 
 b . p a d r e m a v i , 
 b . p a d r e i d m a v i , 
 b . f a c t o r , 
 b . t o t a r t , 
 b a . b o n p p , 
 b a . b o n i f a p l i p p , 
 b a . b o n c c , 
 b a . t o t s a l d o , 
 b . p o r c b o n 1 )   a 
 l e f t   j o i n   # d o c s   d 
 o n   a . p a d r e m a v i   =   d . p a d r e m a v i 
 a n d   a . p a d r e i d m a v i   =   d . p a d r e i d m a v i 
 a n d   d . m o v   ! =   d . p a d r e m a v i 
 w h e r e   d . m o v   =   ' d o c u m e n t o ' 
 a n d   d . v e n c i m i e n t o   >   c o n v e r t ( d a t e t i m e ,   c o n v e r t ( v a r c h a r ( 1 0 ) ,   g e t d a t e ( ) ,   1 0 ) ) 
 g r o u p   b y   a . i d b o n i f , 
 a . b o n i f i c a c i o n , 
 a . p a d r e m a v i , 
 a . p a d r e i d m a v i , 
 a . f a c t o r , 
 a . t o t a r t , 
 a . o t r a s b o n i f p p , 
 a . o t r a s b o n i f c c , 
 a . t o t s a l d o , 
 a . p o r c b o n 1 )   b f 
 l e f t   j o i n   # f a c t u r a   f 
 o n   f . p a d r e m a v i   =   b f . p a d r e m a v i 
 a n d   f . p a d r e i d m a v i   =   b f . p a d r e i d m a v i 
 l e f t   j o i n   # d e t a l l e   v d 
 o n   v d . p a d r e m a v i   =   b f . p a d r e m a v i 
 a n d   v d . p a d r e i d m a v i   =   b f . p a d r e i d m a v i 
 l e f t   j o i n   m a v i b o n i f i c a c i o n l i n e a   m l   w i t h   ( n o l o c k ) 
 o n   b f . i d b o n i f   =   m l . i d b o n i f i c a c i o n 
 a n d   v d . l i n e a   =   m l . l i n e a )   f 
 g r o u p   b y   f . i d b o n i f , 
 f . b o n i f i c a c i o n , 
 f . p a d r e m a v i , 
 f . p a d r e i d m a v i , 
 f . n u m d o c s p e n d , 
 f . n u m d o c s , 
 f . p o r c d e s c t o , 
 f . t o t s a l d o )   g )   b 
 l e f t   j o i n   # b o n f i c a c i o n e s   d c 
 o n   d c . p a d r e m a v i   =   b . p a d r e m a v i 
 a n d   d c . p a d r e i d m a v i   =   b . p a d r e i d m a v i 
 e n d 
 e n d 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # t o t p e n d ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # t o t p e n d 
 s e l e c t 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 c o u n t ( i d )   t o t p e n d i e n t e s   i n t o   # t o t p e n d 
 f r o m   # d o c s 
 w h e r e   e s t a t u s   =   ' p e n d i e n t e ' 
 g r o u p   b y   p a d r e m a v i , 
 p a d r e i d m a v i 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # f i n a l ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # f i n a l 
 s e l e c t 
 r o w _ n u m b e r ( )   o v e r   ( o r d e r   b y   v e n c i m i e n t o )   e n u m , 
 i d , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 r o u n d ( m a x ( s a l d o ) ,   4 )   s a l d o , 
 r o u n d ( m a x ( m o r a t o r i o s ) ,   4 )   m o r a t o r i o s , 
 r o u n d ( m a x ( s a l d o )   -   ( m a x ( b c c )   /   c o u n t ( i d ) )   -   m a x ( b a p ) ,   2 )   +   c a s e 
 w h e n   c o b x p o l   =   ' n o '   t h e n   r o u n d ( m a x ( m o r a t o r i o s ) ,   4 ) 
 e l s e   0 . 0 0 
 e n d   p a t o t a l , 
 r o u n d ( m a x ( s a l d o )   -   m a x ( b p p ) ,   2 )   +   c a s e 
 w h e n   c o b x p o l   =   ' n o '   t h e n   r o u n d ( m a x ( m o r a t o r i o s ) ,   4 ) 
 e l s e   0 . 0 0 
 e n d   c u b r e p p , 
 r o u n d ( m a x ( b p p ) ,   2 )   b o n i f p p , 
 r o u n d ( m a x ( b a p ) ,   2 )   b o n i f a p   i n t o   # f i n a l 
 f r o m   ( s e l e c t 
 d . i d , 
 d . p a d r e m a v i , 
 d . p a d r e i d m a v i , 
 d . s a l d o , 
 d . m o r a t o r i o s , 
 d . v e n c i m i e n t o , 
 i s n u l l ( t . m o n t o b o n i f   /   t o t p e n d i e n t e s ,   0 . 0 0 )   b c c , 
 c a s e 
 w h e n   t d . b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % '   t h e n   i s n u l l ( t d . m o n t o b o n i f ,   0 . 0 0 ) 
 e l s e   0 . 0 0 
 e n d   b p p , 
 c a s e 
 w h e n   t d . b o n i f i c a c i o n   l i k e   ' % a d e l a n t o % '   t h e n   i s n u l l ( t d . m o n t o b o n i f ,   0 . 0 0 ) 
 e l s e   0 . 0 0 
 e n d   b a p , 
 d . c o b x p o l 
 f r o m   ( 
 s e l e c t 
 d c s . i d , 
 d c s . p a d r e m a v i , 
 d c s . p a d r e i d m a v i , 
 d c s . s a l d o , 
 m o r a t o r i o s , 
 t . t o t p e n d i e n t e s , 
 v e n c i m i e n t o , 
 c o b x p o l 
 f r o m   # d o c s   d c s 
 l e f t   j o i n   # f a c t u r a   f 
 o n   f . p a d r e m a v i   =   d c s . p a d r e m a v i 
 a n d   f . p a d r e i d m a v i   =   d c s . p a d r e i d m a v i 
 l e f t   j o i n   # t o t p e n d   t 
 o n   t . p a d r e m a v i   =   f . p a d r e m a v i 
 a n d   t . p a d r e i d m a v i   =   f . p a d r e i d m a v i 
 w h e r e   d c s . e s t a t u s   =   ' p e n d i e n t e ' )   d 
 l e f t   j o i n   # t e m p   t 
 o n   t . p a d r e m a v i   =   d . p a d r e m a v i 
 a n d   t . p a d r e i d m a v i   =   d . p a d r e i d m a v i 
 a n d   t . b o n i f i c a c i o n   l i k e   ' % b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l % ' 
 l e f t   j o i n   # t e m p   t d 
 o n   d . i d   =   t d . d o c t o 
 a n d   t d . b o n i f i c a c i o n   n o t   l i k e   ' % b o n i f i c a c i o n   c o n t a d o   c o m e r c i a l % ' )   d c 
 g r o u p   b y   p a d r e m a v i , 
 p a d r e i d m a v i , 
 i d , 
 v e n c i m i e n t o , 
 c o b x p o l 
 i f   e x i s t s   ( s e l e c t 
 c o u n t ( i d b o n i f i c a c i o n ) 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   l i k e   ' % a d e l a n t o   e n   p a s % ' ) 
 b e g i n 
 i f   ( s e l e c t 
 c o u n t ( i d b o n i f i c a c i o n ) 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' ) 
 =   1 
 a n d   ( s e l e c t 
 s u m ( p a t o t a l   +   m o r a t o r i o s ) 
 f r o m   # f i n a l ) 
 < =   @ i m p o r t e t o t a l 
 b e g i n 
 i f   n o t   e x i s t s   ( s e l e c t 
 t . i d b o n i f i c a c i o n 
 f r o m   # t e m p   t 
 j o i n   m a v i b o n i f i c a c i o n i n c l u y e   i   w i t h   ( n o l o c k ) 
 o n   i . i d b o n i f i c a c i o n   =   t . i d b o n i f i c a c i o n 
 a n d   i . b o n i f i c a c i o n n o   =   ' b o n i f i c a c i o n   a d e l a n t o   e n   p a s ' 
 a n d   i . e n c a s c a d a   ! =   ' n o ' 
 w h e r e   t . b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' ) 
 d e l e t e   f r o m   # b o n i f a p l i c a 
 w h e r e   b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   a d e l a n t o   e n   p a s ' 
 e n d 
 i f   ( s e l e c t 
 c o u n t ( i d b o n i f i c a c i o n ) 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % ' ) 
 =   1 
 a n d   ( s e l e c t 
 s u m ( s a l d o   +   m o r a t o r i o s )   -   s u m ( b o n i f p p )   -   s u m ( b o n i f a p ) 
 f r o m   # f i n a l ) 
 < =   @ i m p o r t e t o t a l 
 b e g i n 
 i f   n o t   e x i s t s   ( s e l e c t 
 t . i d b o n i f i c a c i o n 
 f r o m   # t e m p   t 
 j o i n   m a v i b o n i f i c a c i o n i n c l u y e   i   w i t h   ( n o l o c k ) 
 o n   i . i d b o n i f i c a c i o n   =   t . i d b o n i f i c a c i o n 
 a n d   i . b o n i f i c a c i o n n o   =   ' b o n i f i c a c i o n   a d e l a n t o   e n   p a s ' 
 a n d   i . e n c a s c a d a   ! =   ' n o ' 
 w h e r e   t . b o n i f i c a c i o n   l i k e   ' % a d e l a n t o   e n   p a s % ' ) 
 d e l e t e   f r o m   # b o n i f a p l i c a 
 w h e r e   b o n i f i c a c i o n   =   ' b o n i f i c a c i o n   a d e l a n t o   e n   p a s ' 
 e n d 
 e n d 
 d e c l a r e   @ i n i   i n t , 
 @ f i n   i n t 
 s e l e c t 
 @ i n i   =   m i n ( e n u m )   +   1 , 
 @ f i n   =   m a x ( e n u m ) 
 f r o m   # f i n a l 
 w h i l e   @ i n i   < =   @ f i n 
 b e g i n 
 u p d a t e   # f i n a l 
 s e t   c u b r e p p   =   c u b r e p p   +   ( s e l e c t 
 c u b r e p p 
 f r o m   # f i n a l 
 w h e r e   e n u m   =   @ i n i   -   1 ) 
 w h e r e   e n u m   =   @ i n i 
 s e t   @ i n i   =   @ i n i   +   1 
 e n d 
 i f   ( s e l e c t 
 c o u n t ( i d b o n i f i c a c i o n ) 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   l i k e   ' % c o n t a d o   c o m e r c i a l % ' ) 
 =   1 
 a n d   ( s e l e c t 
 s u m ( p a t o t a l   +   m o r a t o r i o s ) 
 f r o m   # f i n a l ) 
 < =   @ i m p o r t e t o t a l 
 i n s e r t   i n t o   m a v i b o n i f i c a c i o n t e s t   ( d o c t o ,   i d b o n i f i c a c i o n ,   b o n i f i c a c i o n ,   e s t a c i o n ,   m o v ,   m o v i d ,   o r i g e n ,   o r i g e n i d ,   i m p o r t e v e n t a ,   i m p o r t e d o c t o 
 ,   p o r c b o n 1 ,   m o n t o b o n i f ,   f i n a n c i a m i e n t o ,   f a c t o r ,   p l a z o e j e f i n ,   d o c u m e n t o 1 d e ,   d o c u m e n t o t o t a l ,   s u c u r s a l 1 ,   t i p o s u c u r s a l ,   l i n e a v t a ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   i d v e n t a 
 ,   u e n ,   c o n d i c i o n ,   o k ,   o k r e f ,   f e c h a e m i s i o n ,   v e n c i m i e n t o ,   i d c o b r o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s ,   b a s e p a r a a p l i c a r ) 
 s e l e c t 
 d o c t o , 
 i d b o n i f i c a c i o n , 
 b o n i f i c a c i o n , 
 e s t a c i o n , 
 m o v , 
 m o v i d , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i m p o r t e f a c t , 
 i m p o r t e d o c , 
 p o r c b o n , 
 m o n t o b o n i f , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 d o c u m e n t o 1 d e , 
 d o c u m e n t o t o t a l , 
 s u c u r s a l 1 , 
 t i p o s u c u r s a l , 
 l i n e a v t a , 
 d i a s m e n o r e s a , 
 d i a s m a y o r e s a , 
 i d v e n t a , 
 u e n , 
 c o n d i c i o n , 
 o k , 
 o k r e f , 
 f e c h a e m i s i o n f a c t , 
 v e n c i m i e n t o , 
 i d c r o b o , 
 l i n e a c e l u l a r e s , 
 l i n e a c r e d i l a n a s , 
 b a s e p a r a a p l i c a r 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   n o t   l i k e   ' % p a   p u n t u a l % ' 
 e l s e 
 i f   ( s e l e c t 
 s u m ( s a l d o   +   m o r a t o r i o s )   -   s u m ( b o n i f p p )   -   s u m ( b o n i f a p ) 
 f r o m   # f i n a l ) 
 < =   @ i m p o r t e t o t a l 
 i n s e r t   i n t o   m a v i b o n i f i c a c i o n t e s t   ( d o c t o ,   i d b o n i f i c a c i o n ,   b o n i f i c a c i o n ,   e s t a c i o n ,   m o v ,   m o v i d ,   o r i g e n ,   o r i g e n i d ,   i m p o r t e v e n t a ,   i m p o r t e d o c t o 
 ,   p o r c b o n 1 ,   m o n t o b o n i f ,   f i n a n c i a m i e n t o ,   f a c t o r ,   p l a z o e j e f i n ,   d o c u m e n t o 1 d e ,   d o c u m e n t o t o t a l ,   s u c u r s a l 1 ,   t i p o s u c u r s a l ,   l i n e a v t a ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   i d v e n t a 
 ,   u e n ,   c o n d i c i o n ,   o k ,   o k r e f ,   f e c h a e m i s i o n ,   v e n c i m i e n t o ,   i d c o b r o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s ,   b a s e p a r a a p l i c a r ) 
 s e l e c t 
 d o c t o , 
 i d b o n i f i c a c i o n , 
 b o n i f i c a c i o n , 
 e s t a c i o n , 
 m o v , 
 m o v i d , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i m p o r t e f a c t , 
 i m p o r t e d o c , 
 p o r c b o n , 
 m o n t o b o n i f , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 d o c u m e n t o 1 d e , 
 d o c u m e n t o t o t a l , 
 s u c u r s a l 1 , 
 t i p o s u c u r s a l , 
 l i n e a v t a , 
 d i a s m e n o r e s a , 
 d i a s m a y o r e s a , 
 i d v e n t a , 
 u e n , 
 c o n d i c i o n , 
 o k , 
 o k r e f , 
 f e c h a e m i s i o n f a c t , 
 v e n c i m i e n t o , 
 i d c r o b o , 
 l i n e a c e l u l a r e s , 
 l i n e a c r e d i l a n a s , 
 b a s e p a r a a p l i c a r 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   n o t   l i k e   ' % c o n t a d o   c o m e r c i a l % ' 
 e l s e 
 i n s e r t   i n t o   m a v i b o n i f i c a c i o n t e s t   ( d o c t o ,   i d b o n i f i c a c i o n ,   b o n i f i c a c i o n ,   e s t a c i o n ,   m o v ,   m o v i d ,   o r i g e n ,   o r i g e n i d ,   i m p o r t e v e n t a ,   i m p o r t e d o c t o 
 ,   p o r c b o n 1 ,   m o n t o b o n i f ,   f i n a n c i a m i e n t o ,   f a c t o r ,   p l a z o e j e f i n ,   d o c u m e n t o 1 d e ,   d o c u m e n t o t o t a l ,   s u c u r s a l 1 ,   t i p o s u c u r s a l ,   l i n e a v t a ,   d i a s m e n o r e s a ,   d i a s m a y o r e s a ,   i d v e n t a 
 ,   u e n ,   c o n d i c i o n ,   o k ,   o k r e f ,   f e c h a e m i s i o n ,   v e n c i m i e n t o ,   i d c o b r o ,   l i n e a c e l u l a r e s ,   l i n e a c r e d i l a n a s ,   b a s e p a r a a p l i c a r ) 
 s e l e c t 
 d o c t o , 
 i d b o n i f i c a c i o n , 
 b o n i f i c a c i o n , 
 e s t a c i o n , 
 m o v , 
 m o v i d , 
 p a d r e m a v i , 
 p a d r e i d m a v i , 
 i m p o r t e f a c t , 
 i m p o r t e d o c , 
 p o r c b o n , 
 m o n t o b o n i f , 
 f i n a n c i a m i e n t o , 
 f a c t o r , 
 p l a z o e j e f i n , 
 d o c u m e n t o 1 d e , 
 d o c u m e n t o t o t a l , 
 s u c u r s a l 1 , 
 t i p o s u c u r s a l , 
 l i n e a v t a , 
 d i a s m e n o r e s a , 
 d i a s m a y o r e s a , 
 i d v e n t a , 
 u e n , 
 c o n d i c i o n , 
 o k , 
 o k r e f , 
 f e c h a e m i s i o n f a c t , 
 v e n c i m i e n t o , 
 i d c r o b o , 
 l i n e a c e l u l a r e s , 
 l i n e a c r e d i l a n a s , 
 b a s e p a r a a p l i c a r 
 f r o m   # t e m p 
 w h e r e   b o n i f i c a c i o n   l i k e   ' % p a   p u n t u a l % ' 
 i f   @ i m p o r t e t o t a l   > =   ( s e l e c t 
 s u m ( p a t o t a l ) 
 f r o m   # f i n a l ) 
 s e l e c t 
 @ i m p o r t e t o t a l   =   s u m ( s a l d o )   +   s u m ( m o r a t o r i o s ) 
 f r o m   # f i n a l 
 e l s e 
 i f   @ i m p o r t e t o t a l   > =   ( s e l e c t 
 s u m ( s a l d o   +   m o r a t o r i o s )   -   s u m ( b o n i f p p )   -   s u m ( b o n i f a p ) 
 f r o m   # f i n a l ) 
 s e l e c t 
 @ i m p o r t e t o t a l   =   s u m ( s a l d o )   +   s u m ( m o r a t o r i o s ) 
 f r o m   # f i n a l 
 e l s e 
 i f   @ i m p o r t e t o t a l   <   ( s e l e c t 
 s u m ( p a t o t a l ) 
 f r o m   # f i n a l ) 
 s e l e c t 
 @ i m p o r t e t o t a l   =   i s n u l l ( s u m ( b o n i f p p ) ,   0 )   +   @ i m p o r t e t o t a l 
 f r o m   ( s e l e c t 
 c a s e 
 w h e n   b o n i f p p   >   s a l d o   t h e n   s a l d o 
 e l s e   b o n i f p p 
 e n d   a s   b o n i f p p 
 f r o m   # f i n a l 
 w h e r e   c u b r e p p   < =   @ i m p o r t e t o t a l )   f 
 s e l e c t 
 @ i m p o r t e t o t a l 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # f a c t u r a ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # f a c t u r a 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # d o c s ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # d o c s 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # b o n i f a p l i c a ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # b o n i f a p l i c a 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # b o n f i c a c i o n e s ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # b o n f i c a c i o n e s 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # t e m p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # t e m p 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # b o n i f a p l i p p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # b o n i f a p l i p p 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # a r t c a n c ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # a r t c a n c 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # d e t a l l e ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # d e t a l l e 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # o t r o s d a t o s ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # o t r o s d a t o s 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # t o t p e n d ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # t o t p e n d 
 i f   e x i s t s   ( s e l e c t 
 n a m e 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # f i n a l ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # f i n a l 
 e n d 