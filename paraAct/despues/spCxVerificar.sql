u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p c x v e r i f i c a r ] 
 @ i d   i n t , 
 @ a c c i o n   c h a r ( 2 0 ) , 
 @ e m p r e s a   c h a r ( 5 ) , 
 @ u s u a r i o   c h a r ( 1 0 ) , 
 @ a u t o r i z a c i o n   c h a r ( 1 0 ) , 
 @ m e n s a j e   i n t , 
 @ m o d u l o   c h a r ( 5 ) , 
 @ m o v   c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ m o v t i p o   c h a r ( 2 0 ) , 
 @ m o v m o n e d a   c h a r ( 1 0 ) , 
 @ m o v t i p o c a m b i o   f l o a t , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ c o n d i c i o n   v a r c h a r ( 5 0 )   o u t p u t , 
 @ v e n c i m i e n t o   d a t e t i m e   o u t p u t , 
 @ f o r m a p a   v a r c h a r ( 5 0 ) , 
 @ r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ c o n t a c t o   c h a r ( 1 0 ) , 
 @ c o n t a c t o t i p o   c h a r ( 2 0 ) , 
 @ c o n t a c t o e n v i a r a   i n t , 
 @ c o n t a c t o m o n e d a   c h a r ( 1 0 ) , 
 @ c o n t a c t o f a c t o r   f l o a t , 
 @ c o n t a c t o t i p o c a m b i o   f l o a t , 
 @ i m p o r t e   m o n e y , 
 @ v a l e s c o b r a d o s   m o n e y , 
 @ i m p u e s t o s   m o n e y , 
 @ r e t e n c i o n   m o n e y , 
 @ r e t e n c i o n 2   m o n e y , 
 @ r e t e n c i o n 3   m o n e y , 
 @ s a l d o   m o n e y , 
 @ c t a d i n e r o   c h a r ( 1 0 ) , 
 @ a g e n t e   c h a r ( 1 0 ) , 
 @ a p l i c a m a n u a l   b i t , 
 @ c o n d e s g l o s e   b i t , 
 @ c o b r o d e s g l o s a d o   m o n e y , 
 @ c o b r o d e l e f e c t i v o   m o n e y , 
 @ c o b r o c a m b i o   m o n e y , 
 @ i n d i r e c t o   b i t , 
 @ c o n e x i o n   b i t , 
 @ s i n c r o f i n a l   b i t , 
 @ s u c u r s a l   i n t , 
 @ s u c u r s a l d e s t i n o   i n t , 
 @ s u c u r s a l o r i g e n   i n t , 
 @ e s t a t u s n u e v o   c h a r ( 1 5 ) , 
 @ a f e c t a r c a n t i d a d p e n d i e n t e   b i t , 
 @ a f e c t a r c a n t i d a d a   b i t , 
 @ c f g c o n t x   b i t , 
 @ c f g c o n t x g e n e r a r   c h a r ( 2 0 ) , 
 @ c f g e m b a r c a r   b i t , 
 @ a u t o a j u s t e   m o n e y , 
 @ a u t o a j u s t e m o v   m o n e y , 
 @ c f g d e s c u e n t o r e c a r s   b i t , 
 @ c f g f o r m a c o b r o d a   v a r c h a r ( 5 0 ) , 
 @ c f g r e f i n a n c i a m i e n t o t a s a   f l o a t , 
 @ c f g a n t i c i p o s f a c t u r a d o s   b i t , 
 @ c f g v a l i d a r p p m o r o s o s   b i t , 
 @ c f g a c   b i t , 
 @ p a g a r e s   b i t , 
 @ o r i g e n t i p o   c h a r ( 1 0 ) , 
 @ o r i g e n m o v t i p o   c h a r ( 2 0 ) , 
 @ m o v a p l i c a   c h a r ( 2 0 ) , 
 @ m o v a p l i c a i d   v a r c h a r ( 2 0 ) , 
 @ m o v a p l i c a m o v t i p o   c h a r ( 2 0 ) , 
 @ a g e n t e n o m i n a   b i t , 
 @ r e d o n d e o m o n e t a r i o s   i n t , 
 @ a u t o r i z a r   b i t   o u t p u t , 
 @ o k   i n t   o u t p u t , 
 @ o k r e f   v a r c h a r ( 2 5 5 )   o u t p u t , 
 @ i n s t r u c c i o n e s _ e s p   v a r c h a r ( 2 0 )   =   n u l l 
 a s   b e g i n 
 d e c l a r e 
 @ d a   b i t , 
 @ a p l i c a m o v   c h a r ( 2 0 ) , 
 @ a p l i c a m o v i d   v a r c h a r ( 2 0 ) , 
 @ a p l i c a s a l d o   m o n e y , 
 @ a p l i c a i m p o r t e t o t a l   m o n e y , 
 @ a p l i c a c o n t a c t o   c h a r ( 1 0 ) , 
 @ a p l i c a m o n e d a   c h a r ( 1 0 ) , 
 @ a p l i c a a f o r o   m o n e y , 
 @ m o v a p l i c a e s t a t u s   c h a r ( 1 5 ) , 
 @ c o n t a c t o i m p o r t e   m o n e y , 
 @ c a n t s a l d o   m o n e y , 
 @ i m p o r t e t o t a l   m o n e y , 
 @ i m p o r t e a p l i c a d o   m o n e y , 
 @ e f e c t i v o   m o n e y , 
 @ a n t i c i p o s   m o n e y , 
 @ c t a d i n e r o m o n e d a   c h a r ( 1 0 ) , 
 @ c t a d i n e r o t i p o   c h a r ( 2 0 ) , 
 @ t i e n e d e s c u e n t o r e c a r s   b i t , 
 @ a p l i c a p o s f e c h a d o   b i t , 
 @ c o n t a c t o e s t a t u s   c h a r ( 1 5 ) , 
 @ v a l e e s t a t u s   c h a r ( 1 5 ) , 
 @ a f o r o i m p o r t e   m o n e y , 
 @ t a r j e t a s c o b r a d a s   m o n e y , 
 @ f o r m a c o b r o t a r j e t a s   v a r c h a r ( 5 0 ) , 
 @ i m p o r t e 1   m o n e y , 
 @ i m p o r t e 2   m o n e y , 
 @ i m p o r t e 3   m o n e y , 
 @ i m p o r t e 4   m o n e y , 
 @ i m p o r t e 5   m o n e y , 
 @ f o r m a c o b r o 1   v a r c h a r ( 5 0 ) , 
 @ f o r m a c o b r o 2   v a r c h a r ( 5 0 ) , 
 @ f o r m a c o b r o 3   v a r c h a r ( 5 0 ) , 
 @ f o r m a c o b r o 4   v a r c h a r ( 5 0 ) , 
 @ f o r m a c o b r o 5   v a r c h a r ( 5 0 ) 
 s e l e c t   @ a p l i c a p o s f e c h a d o   =   0 , 
 @ a u t o r i z a r   =   0 , 
 @ a f o r o i m p o r t e   =   0 . 0 , 
 @ d a   =   0 
 i f   @ m o v t i p o   i n   ( ' c x c . v v ' ,   ' c x c . o v ' ,   ' c x c . d v ' ,   ' c x c . a v ' ,   ' c x c . s d ' ,   ' c x c . s c h ' ,   ' c x p . s d ' ,   ' c x p . s c h ' )   a n d   @ c o n e x i o n   =   0   s e l e c t   @ o k   =   6 0 1 6 0 
 i f   @ m o v t i p o   n o t   i n   ( ' c x c . c ' , ' c x c . c d ' , ' c x c . d ' , ' c x c . d m ' , ' c x c . a ' , ' c x c . r a ' , ' c x c . a r ' , ' c x c . a a ' , ' c x c . d e ' , ' c x c . f ' , ' c x c . f a ' , ' c x c . d f a ' , ' c x c . a f ' , ' c x c . c a ' , ' c x c . v v ' , ' c x c . o v ' , ' c x c . i m ' , ' c x c . r m ' , ' c x c . n c ' , ' c x c . d v ' , ' c x c . n c p ' , ' c x c . c a p ' , 
 ' c x p . a ' , ' c x p . a a ' , ' c x p . d e ' , ' c x p . f ' , ' c x p . a f ' , ' c x p . c a ' , ' c x p . n c ' , ' c x p . n c p ' , ' c x p . c a p ' , ' c x p . n c f ' , 
 ' a g e n t . p ' , ' a g e n t . c o ' , ' c x c . f a c ' , ' c x p . f a c ' )   a n d   @ i m p u e s t o s   < >   0 . 0 
 s e l e c t   @ o k   =   2 0 8 7 0 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 b e g i n 
 i f   @ i n d i r e c t o   =   1   a n d   @ c o n e x i o n   =   0   s e l e c t   @ o k   =   6 0 1 8 0 
 i f   @ o r i g e n m o v t i p o   =   ' c x c . n c f '   a n d   @ c o n e x i o n   =   0   s e l e c t   @ o k   =   6 0 1 8 0 
 i f   @ m o v t i p o   i n   ( ' c x c . f ' ,   ' c x c . c a ' ,   ' c x c . c a p ' ,   ' c x c . c a d ' ,   ' c x c . d ' ,   ' c x c . d m ' ,   ' c x p . f ' ,   ' c x p . c a ' ,   ' c x p . c a p ' ,   ' c x p . c a d ' ,   ' c x p . d ' ,   ' c x p . d m ' )   a n d   @ c o n d i c i o n   i s   n o t   n u l l 
 b e g i n 
 i f   @ c f g a c   =   1   o r   e x i s t s ( s e l e c t   *   f r o m   c o n d i c i o n   w h e r e   c o n d i c i o n   =   @ c o n d i c i o n   a n d   d a   =   1 ) 
 b e g i n 
 e x e c   s p c x c a n c e l a r d o c a u t o   @ e m p r e s a ,   @ u s u a r i o ,   @ m o d u l o ,   @ i d ,   @ m o v ,   @ m o v i d ,   1 ,   n u l l ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 i f   @ o k   i s   n u l l   s e l e c t   @ d a   =   1 
 e n d 
 e n d 
 i f   @ d a = 0   a n d   @ m o v t i p o   i n   ( ' c x c . f ' , ' c x c . f a ' , ' c x c . f a c ' , ' c x c . d a c ' , ' c x c . a f ' , ' c x c . c a ' ,   ' c x c . c a d ' , ' c x c . c a p ' , ' c x c . v v ' , ' c x c . o v ' , ' c x c . i m ' , ' c x c . r m ' , ' c x c . d ' , ' c x c . d m ' , ' c x c . d a ' , ' c x c . d p ' ,   ' c x c . c d ' , 
 ' c x p . f ' , ' c x p . a f ' , ' c x p . f a c ' , ' c x p . d a c ' , ' c x p . c a ' , ' c x p . c a d ' , ' c x p . c a p ' , ' c x p . d ' , ' c x p . d m ' , ' c x p . p a g ' , ' c x p . d a ' , ' c x p . d p ' ,   ' c x p . c d ' ,   ' c x p . f a c ' , 
 ' a g e n t . c ' ,   ' a g e n t . d ' ,   ' a g e n t . a ' ,   ' c x c . a ' , ' c x c . a r ' , ' c x c . n c ' , ' c x c . n c d ' , ' c x c . n c f ' , ' c x c . d v ' , ' c x c . n c p ' , ' c x p . a ' , ' c x p . n c ' , ' c x p . n c d ' , ' c x p . n c f ' , ' c x p . n c p ' , 
 ' c x c . s d ' ,   ' c x c . s c h ' ,   ' c x p . s d ' ,   ' c x p . s c h ' ) 
 b e g i n 
 i f   n o t   ( @ m o v t i p o   =   ' c x c . o v '   a n d   @ c o n e x i o n   =   1 ) 
 b e g i n 
 i f   @ m o v m o n e d a   =   @ c o n t a c t o m o n e d a 
 b e g i n 
 i f   r o u n d ( @ s a l d o   +   @ a f o r o i m p o r t e ,   2 )   < >   r o u n d ( @ i m p o r t e   +   @ i m p u e s t o s   -   @ r e t e n c i o n   -   @ r e t e n c i o n 2   -   @ r e t e n c i o n 3 ,   2 )   s e l e c t   @ o k   =   6 0 0 6 0 
 e n d   e l s e 
 b e g i n 
 i f   r o u n d ( ( @ s a l d o   +   @ a f o r o i m p o r t e )   *   @ c o n t a c t o t i p o c a m b i o ,   2 )   < >   r o u n d ( ( @ i m p o r t e   +   @ i m p u e s t o s   -   @ r e t e n c i o n   -   @ r e t e n c i o n 2   -   @ r e t e n c i o n 3 )   *   @ m o v t i p o c a m b i o ,   2 )   s e l e c t   @ o k   =   6 0 0 6 0 
 e n d 
 e n d 
 i f   @ o k   i s   n o t   n u l l   a n d   @ m o v t i p o   i n   ( ' c x c . c a ' , ' c x c . c a d ' , ' c x c . c a p ' , ' c x c . a ' , ' c x c . a r ' , ' c x c . n c ' , ' c x c . n c d ' , ' c x c . n c f ' , ' c x c . d v ' , ' c x c . n c p ' , 
 ' c x p . c a ' , ' c x p . c a d ' , ' c x p . c a p ' , ' c x p . a ' , ' c x p . n c ' , ' c x p . n c d ' , ' c x p . n c f ' , ' c x p . n c p ' ) 
 b e g i n 
 i f   @ m o d u l o   =   ' c x c '   a n d   e x i s t s   ( s e l e c t   *   f r o m   c x c   c   ,   c x c d   d   w h e r e   c . i d   =   @ i d   a n d   c . a p l i c a m a n u a l   =   1   a n d   c . i d   =   d . i d )   s e l e c t   @ o k   =   n u l l   e l s e 
 i f   @ m o d u l o   =   ' c x p '   a n d   e x i s t s   ( s e l e c t   *   f r o m   c x p   c   ,   c x p d   d   w h e r e   c . i d   =   @ i d   a n d   c . a p l i c a m a n u a l   =   1   a n d   c . i d   =   d . i d )   s e l e c t   @ o k   =   n u l l 
 e n d 
 i f   @ o r i g e n t i p o   i n   ( ' p a g a r e ' , ' p p / r e c a r '   , ' r e t e n c i o n ' )   a n d   @ c o n e x i o n   =   0   s e l e c t   @ o k   =   6 0 0 7 2 
 i f   @ o r i g e n t i p o   =   ' e n d o s o '   a n d   @ c o n e x i o n   =   0   s e l e c t   @ o k   =   6 0 0 7 0 
 e n d 
 i f   @ m o v t i p o   =   ' c x c . f a ' 
 b e g i n 
 s e l e c t   @ c a n t s a l d o   =   0 . 0 
 s e l e c t   @ c a n t s a l d o   =   s u m ( i s n u l l ( r o u n d ( s a l d o ,   @ r e d o n d e o m o n e t a r i o s ) ,   0 . 0 ) )   f r o m   s a l d o   w h e r e   r a m a   =   ' c a n t '   a n d   e m p r e s a   =   @ e m p r e s a   a n d   m o n e d a   =   @ m o v m o n e d a   a n d   c u e n t a   =   @ c o n t a c t o 
 i f   r o u n d ( @ i m p o r t e   +   @ i m p u e s t o s   -   @ r e t e n c i o n   -   @ r e t e n c i o n 2   -   @ r e t e n c i o n 3 ,   @ r e d o n d e o m o n e t a r i o s )   >   @ c a n t s a l d o 
 s e l e c t   @ o k   =   3 0 4 1 0 
 e n d 
 i f   @ c o n e x i o n   =   0 
 b e g i n 
 i f   @ o r i g e n m o v t i p o   i s   n o t   n u l l 
 b e g i n 
 i f   @ m o v t i p o   i n   ( ' c x c . f ' , ' c x c . c a ' ,   ' c x c . f a ' , ' c x c . a f ' , ' c x c . a ' , ' c x c . a r ' , ' c x c . n c ' , ' c x c . n c d ' , ' c x c . n c f ' , ' c x c . d v ' , ' c x c . n c p ' , ' c x c . a j e ' ,   ' c x p . f ' , ' c x p . a f ' , ' c x p . a ' , ' c x p . n c ' , ' c x p . n c d ' , ' c x p . n c f ' , ' c x p . n c p ' , ' c x p . a j e ' ,   ' a g e n t . c ' ,   ' a g e n t . d ' ) 
 i f   e x i s t s   ( s e l e c t   *   f r o m   m o v f l u j o   w h e r e   c a n c e l a d o   =   0   a n d   e m p r e s a   =   @ e m p r e s a   a n d   d m o d u l o   =   @ m o d u l o   a n d   d i d   =   @ i d   a n d   o m o d u l o   < >   d m o d u l o ) 
 s e l e c t   @ o k   =   6 0 0 7 0 
 i f   @ m o v t i p o   i n   ( ' c x c . a ' ,   ' c x c . a r ' ,   ' c x p . a ' )   a n d   @ o r i g e n m o v t i p o   i s   n o t   n u l l 
 s e l e c t   @ o k   =   6 0 0 7 0 
 e n d 
 e n d 
 e n d   e l s e 
 b e g i n 
 i f   @ m o v t i p o   i n   ( ' c x c . r e ' ,   ' c x p . r e ' )   a n d   @ o r i g e n t i p o   < >   ' a u t o / r e '   s e l e c t   @ o k   =   2 5 4 1 0 
 i f   @ m o d u l o   =   ' c x c '   s e l e c t   @ c o n t a c t o e s t a t u s   =   e s t a t u s   f r o m   c t e   w h e r e   c l i e n t e   =   @ c o n t a c t o   e l s e 
 i f   @ m o d u l o   =   ' c x p '   s e l e c t   @ c o n t a c t o e s t a t u s   =   e s t a t u s   f r o m   p r o v   w h e r e   p r o v e e d o r   =   @ c o n t a c t o   e l s e 
 i f   @ m o d u l o   =   ' a g e n t '   s e l e c t   @ c o n t a c t o e s t a t u s   =   e s t a t u s   f r o m   a g e n t e   w h e r e   a g e n t e   =   @ c o n t a c t o 
 i f   @ m o d u l o   =   ' c x p '   a n d   @ c o n t a c t o e s t a t u s   =   ' b l o q u e a d o '   a n d   @ a u t o r i z a c i o n   i s   n u l l 
 b e g i n 
 s e l e c t   @ o k   =   6 5 0 3 2 ,   @ o k r e f   =   @ c o n t a c t o ,   @ a u t o r i z a r   =   1 
 e x e c   x p o k _ 6 5 0 3 2   @ e m p r e s a ,   @ u s u a r i o ,   @ a c c i o n ,   @ m o d u l o ,   @ i d ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e n d 
 i f   @ m o v m o n e d a   =   @ c o n t a c t o m o n e d a   a n d   @ m o v t i p o c a m b i o   < >   @ c o n t a c t o t i p o c a m b i o   a n d   @ m o v t i p o   n o t   i n   ( ' c x c . n c f ' ,   ' c x p . n c f ' )   s e l e c t   @ o k   =   3 5 1 1 0 
 i f   @ c o n t a c t o   i s   n u l l 
 i f   @ m o d u l o   =   ' c x c '   s e l e c t   @ o k   =   4 0 0 1 0   e l s e   s e l e c t   @ o k   =   4 0 0 2 0 
 i f   @ m o v t i p o   i n   ( ' c x c . f a ' , ' c x c . a f ' , ' c x c . d e ' , ' c x c . d i ' , ' c x c . a n c ' , ' c x c . a c a ' , ' c x p . a c a ' , ' c x c . r a ' , ' c x c . f a c ' , ' c x c . d a c ' , ' c x c . a j e ' , ' c x c . a j r ' ,   ' c x c . d a ' ,   ' c x p . a f ' , ' c x p . d e ' , ' c x p . a n c ' , ' c x p . r a ' , ' c x p . f a c ' , ' c x p . d a c ' , ' c x p . a j e ' , ' c x p . a j r ' ,   ' c x p . d a ' ) 
 a n d   @ m o v m o n e d a   < >   @ c o n t a c t o m o n e d a 
 s e l e c t   @ o k   =   3 0 0 8 0 
 i f   @ m o v t i p o   i n   ( ' c x c . f ' , ' c x c . f a ' , ' c x c . a f ' , ' c x c . c a ' ,   ' c x c . c a d ' , ' c x c . c a p ' , ' c x c . v v ' , ' c x c . c d ' , ' c x c . d ' , ' c x c . d m ' , ' c x c . d a ' , ' c x c . d p ' , ' c x c . n c p ' ,   ' c x p . f ' , ' c x p . a f ' , ' c x p . c a ' ,   ' c x p . c a d ' , ' c x p . c a p ' , ' c x p . c d ' , ' c x p . d ' , ' c x p . d m ' ,   ' c x p . p a g ' , ' c x p . d a ' , ' c x p . d p ' , ' c x p . n c p ' ) 
 e x e c   s p v e r i f i c a r v e n c i m i e n t o   @ c o n d i c i o n ,   @ v e n c i m i e n t o ,   @ f e c h a e m i s i o n ,   @ o k   o u t p u t 
 i f   @ m o v t i p o   =   ' c x c . c '   a n d   @ c o n d e s g l o s e   =   1 
 b e g i n 
 i f   @ c o b r o c a m b i o   >   @ c o b r o d e s g l o s a d o   s e l e c t   @ o k   =   3 0 2 5 0   e l s e 
 i f   @ c o b r o d e l e f e c t i v o   <   0 . 0   s e l e c t   @ o k   =   3 0 1 0 0 
 e n d 
 i f   @ m o v t i p o   i n   ( ' c x c . a e ' , ' c x c . d e ' ,   ' c x p . a e ' , ' c x p . d e ' )   o r   ( @ m o v t i p o   =   ' c x c . c '   a n d   @ c o n d e s g l o s e   =   1   a n d   @ c o b r o d e l e f e c t i v o   >   0 . 0 ) 
 b e g i n 
 s e l e c t   @ e f e c t i v o   =   0 . 0 
 i f   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 s e l e c t   @ e f e c t i v o   =   i s n u l l ( s a l d o ,   0 . 0 )   f r o m   c x c e f e c t i v o   w h e r e   e m p r e s a   =   @ e m p r e s a   a n d   c l i e n t e   =   @ c o n t a c t o   a n d   m o n e d a   =   @ m o v m o n e d a 
 i f   @ m o v t i p o   =   ' c x c . c ' 
 b e g i n 
 i f   r o u n d ( @ c o b r o d e l e f e c t i v o ,   0 )   >   r o u n d ( - @ e f e c t i v o ,   0 )   s e l e c t   @ o k   =   3 0 0 9 0 
 e n d   e l s e 
 i f   r o u n d ( @ i m p o r t e ,   0 )   >   r o u n d ( - @ e f e c t i v o ,   0 )   a n d   @ m o v t i p o   n o t   i n   ( ' c x c . d e ' ,   ' c x p . d e ' )   s e l e c t   @ o k   =   3 0 0 9 0 
 e n d   e l s e 
 i f   @ m o d u l o   =   ' c x p ' 
 b e g i n 
 s e l e c t   @ e f e c t i v o   =   i s n u l l ( s a l d o ,   0 . 0 )   f r o m   c x p e f e c t i v o   w h e r e   e m p r e s a   =   @ e m p r e s a   a n d   p r o v e e d o r   =   @ c o n t a c t o   a n d   m o n e d a   =   @ m o v m o n e d a 
 i f   r o u n d ( @ i m p o r t e ,   0 )   <   r o u n d ( @ e f e c t i v o ,   0 )   s e l e c t   @ o k   =   3 0 0 9 0 
 e n d 
 e n d 
 i f   @ m o v t i p o   =   ' c x c . f a '   a n d   @ c f g a n t i c i p o s f a c t u r a d o s   =   0   s e l e c t   @ o k   =   7 0 0 7 0 
 i f   @ m o v t i p o   =   ' c x p . p a g '   a n d   @ p a g a r e s   =   0   s e l e c t   @ o k   =   3 0 5 6 0 
 i f   @ o k   i s   n o t   n u l l   r e t u r n 
 i f   ( @ i m p o r t e   +   @ i m p u e s t o s   -   @ r e t e n c i o n   -   @ r e t e n c i o n 2   -   @ r e t e n c i o n 3   <   0 . 0   o r   r o u n d ( @ i m p o r t e ,   2 )   <   0 . 0   o r   r o u n d ( @ i m p u e s t o s ,   2 )   <   0 . 0 )   a n d   @ m o v t i p o   n o t   i n   ( ' c x c . a j e ' ,   ' c x c . a j r ' ,   ' c x c . a j m ' ,   ' c x c . a j a ' ,   ' c x p . a j e ' ,   ' c x p . a j r ' ,   ' c x p . a j m ' ,   ' c x p . a j a ' ,   ' a g e n t . p ' , 
 ' a g e n t . c o ' ,   ' a g e n t . c ' , ' a g e n t . d ' ,   ' c x c . r e ' ,   ' c x p . r e ' )   s e l e c t   @ o k   =   3 0 1 0 0 
 s e l e c t   @ i m p o r t e t o t a l   =   @ i m p o r t e   +   @ i m p u e s t o s   -   @ r e t e n c i o n   -   @ r e t e n c i o n 2   -   @ r e t e n c i o n 3 
 i f   @ m o v t i p o   i n   ( ' c x c . a n c ' ,   ' c x c . a c a ' ,   ' c x p . a c a ' ,   ' c x c . r a ' ,   ' c x c . f a c ' ,   ' c x c . d a c ' ,   ' c x p . a n c ' ,   ' c x p . r a ' ,   ' c x p . f a c ' ,   ' c x p . d a c ' )   a n d   @ a c c i o n   < >   ' c a n c e l a r ' 
 b e g i n 
 i f   @ m o v a p l i c a   i s   n u l l   o r   @ m o v a p l i c a i d   i s   n u l l   s e l e c t   @ o k   =   3 0 1 7 0 
 i f   @ o k   i s   n u l l 
 b e g i n 
 i f   @ m o d u l o   =   ' c x c '   s e l e c t   @ a p l i c a s a l d o   =   i s n u l l ( s a l d o ,   0 . 0 ) ,   @ a p l i c a i m p o r t e t o t a l   =   i s n u l l ( i m p o r t e ,   0 . 0 )   +   i s n u l l ( i m p u e s t o s ,   0 . 0 ) ,   @ a p l i c a m o n e d a   =   c l i e n t e m o n e d a ,   @ a p l i c a c o n t a c t o   =   c l i e n t e ,   @ m o v a p l i c a e s t a t u s   =   e s t a t u s   f r o m   c x c   w h e r e   e m p r e s a   =   @ e m p r e s a   a n d   m o v   =   @ m o v a p l i c a   a n d   m o v i d   =   @ m o v a p l i c a i d   a n d   e s t a t u s   n o t   i n   ( ' s i n a f e c t a r ' ,   ' c o n f i r m a r ' ,   ' b o r r a d o r ' ,   ' c a n c e l a d o ' )   e l s e 
 i f   @ m o d u l o   =   ' c x p '   s e l e c t   @ a p l i c a s a l d o   =   i s n u l l ( s a l d o ,   0 . 0 ) ,   @ a p l i c a i m p o r t e t o t a l   =   i s n u l l ( i m p o r t e ,   0 . 0 )   +   i s n u l l ( i m p u e s t o s ,   0 . 0 ) ,   @ a p l i c a a f o r o   =   i s n u l l ( a f o r o ,   0 . 0 ) ,   @ a p l i c a m o n e d a   =   p r o v e e d o r m o n e d a ,   @ a p l i c a c o n t a c t o   =   p r o v e e d o r ,   @ m o v a p l i c a e s t a t u s   =   e s t a t u s 
 f r o m   c x p   w h e r e   e m p r e s a   =   @ e m p r e s a   a n d   m o v   =   @ m o v a p l i c a   a n d   m o v i d   =   @ m o v a p l i c a i d   a n d   e s t a t u s   n o t   i n   ( ' s i n a f e c t a r ' ,   ' c o n f i r m a r ' ,   ' b o r r a d o r ' ,   ' c a n c e l a d o ' ) 
 i f   @ i m p o r t e t o t a l   >   @ a p l i c a s a l d o   s e l e c t   @ o k   =   3 0 1 8 0   e l s e 
 i f   @ m o v a p l i c a e s t a t u s   < >   ' p e n d i e n t e '   s e l e c t   @ o k   =   3 0 1 9 0   e l s e 
 i f   @ m o v m o n e d a   < >   @ a p l i c a m o n e d a   s e l e c t   @ o k   =   2 0 1 9 6   e l s e 
 i f   @ m o v t i p o   i n   ( ' c x c . a n c ' ,   ' c x c . a c a ' ,   ' c x p . a c a ' ,   ' c x p . a n c ' )   a n d   @ c o n t a c t o   < >   @ a p l i c a c o n t a c t o   s e l e c t   @ o k   =   3 0 1 9 2   e l s e 
 i f   @ m o v t i p o   i n   ( ' c x c . r a ' ,   ' c x p . r a ' )   a n d   @ c o n t a c t o   =   @ a p l i c a c o n t a c t o   s e l e c t   @ o k   =   3 0 5 0 0   e l s e 
 i f   @ m o v t i p o   i n   ( ' c x c . f a c ' ,   ' c x c . d a c ' ,   ' c x p . f a c ' ,   ' c x p . d a c ' ) 
 b e g i n 
 i f   ( @ c o n t a c t o   =   @ a p l i c a c o n t a c t o )   s e l e c t   @ o k   =   3 0 5 0 5 
 e n d 
 e n d 
 e n d 
 i f   @ m o v t i p o   i n   ( ' c x c . c d ' ,   ' c x p . c d ' )   a n d   @ c t a d i n e r o   i s   n u l l   s e l e c t   @ o k   =   4 0 0 3 0 
 i f   @ m o v t i p o   i n   ( ' c x c . r a ' ,   ' c x p . r a ' )   a n d   @ m o v a p l i c a m o v t i p o   n o t   i n   ( ' c x c . a ' ,   ' c x c . a r ' ,   ' c x p . a ' )   s e l e c t   @ o k   =   2 0 1 9 8 
 i f   @ m o v t i p o   =   ' a g e n t . a '   a n d   @ a g e n t e n o m i n a   =   1   s e l e c t   @ o k   =   3 0 3 6 0 
 i f   @ m o v t i p o   i n   ( ' c x c . c ' , ' c x c . a ' , ' c x c . a r ' , ' c x c . a a ' , ' c x c . d e ' , ' c x c . d i ' , ' c x c . d c ' , 
 ' c x p . p ' , ' c x p . a ' , ' c x p . a a ' , ' c x p . d e ' , ' c x p . d c ' , ' c x c . d f a ' , 
 ' a g e n t . p ' , ' a g e n t . c o ' , ' a g e n t . a ' )   a n d   @ c t a d i n e r o   i s   n o t   n u l l   a n d   @ o k   i s   n u l l 
 b e g i n 
 s e l e c t   @ c t a d i n e r o m o n e d a   =   m o n e d a ,   @ c t a d i n e r o t i p o   =   t i p o   f r o m   c t a d i n e r o   w h e r e   c t a d i n e r o   =   @ c t a d i n e r o 
 i f   @ c t a d i n e r o t i p o   < >   ' c a j a '   a n d   @ m o v m o n e d a   < >   @ c t a d i n e r o m o n e d a   s e l e c t   @ o k   =   3 0 2 0 0 
 e n d 
 i f   ( ( @ m o v t i p o   i n   ( ' c x c . c ' , ' c x c . a j m ' , ' c x c . a j a ' , ' c x c . n e t ' , ' c x c . n c ' , ' c x c . n c d ' , ' c x c . c a ' , ' c x c . c a d ' , ' c x c . c a p ' , ' c x c . n c f ' , ' c x c . d v ' , ' c x c . n c p ' , ' c x c . d ' , ' c x c . d m ' , ' c x c . d a ' , ' c x c . d p ' , ' c x c . a e ' , ' c x c . a n c ' , ' c x c . a c a ' , ' c x p . a c a ' , ' c x c . d c ' , 
 ' c x p . p ' , ' c x p . a j m ' , ' c x p . a j a ' , ' c x p . n e t ' , ' c x p . n c ' , ' c x p . n c d ' , ' c x p . c a ' , ' c x p . c a d ' , ' c x p . c a p ' , ' c x p . n c f ' , ' c x p . n c p ' , ' c x p . d ' , ' c x p . d m ' ,   ' c x p . p a g ' , ' c x p . d a ' , ' c x p . d p ' , ' c x p . a e ' , ' c x p . a n c ' , ' c x p . d c ' )   a n d   @ a p l i c a m a n u a l   =   1 )   o r 
 ( @ m o v t i p o   i n   ( ' c x c . i m ' ,   ' c x c . r m ' ,   ' a g e n t . p ' , ' a g e n t . c o ' ) ) ) 
 a n d   @ a c c i o n   i n   ( ' a f e c t a r ' ,   ' v e r i f i c a r ' )   a n d   @ o k   i s   n u l l 
 b e g i n 
 e x e c   s p c x a p l i c a r   @ i d ,   @ a c c i o n ,   @ e m p r e s a ,   @ u s u a r i o ,   @ m o d u l o ,   @ m o v ,   n u l l ,   @ m o v t i p o ,   @ m o v m o n e d a ,   @ m o v t i p o c a m b i o , 
 n u l l ,   n u l l ,   n u l l ,   @ c o n d i c i o n   o u t p u t ,   @ v e n c i m i e n t o   o u t p u t ,   n u l l ,   @ f e c h a e m i s i o n ,   n u l l ,   n u l l ,   n u l l , 
 @ c o n t a c t o ,   @ c o n t a c t o e n v i a r a ,   @ c o n t a c t o m o n e d a ,   @ c o n t a c t o f a c t o r ,   @ c o n t a c t o t i p o c a m b i o ,   @ a g e n t e ,   @ i m p o r t e ,   @ i m p u e s t o s ,   @ r e t e n c i o n ,   @ r e t e n c i o n 2 ,   @ r e t e n c i o n 3 ,   @ i m p o r t e t o t a l , 
 @ c o n e x i o n ,   @ s i n c r o f i n a l ,   @ s u c u r s a l ,   @ s u c u r s a l d e s t i n o ,   @ s u c u r s a l o r i g e n ,   @ o r i g e n t i p o ,   @ o r i g e n m o v t i p o ,   @ m o v a p l i c a ,   @ m o v a p l i c a i d ,   @ m o v a p l i c a m o v t i p o , 
 @ c f g c o n t x ,   @ c f g c o n t x g e n e r a r ,   @ c f g e m b a r c a r ,   @ a u t o a j u s t e ,   @ a u t o a j u s t e m o v ,   @ c f g d e s c u e n t o r e c a r s ,   @ c f g r e f i n a n c i a m i e n t o t a s a , 
 0 ,   n u l l ,   n u l l ,   0 ,   n u l l , 
 0 ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   @ c f g a c , 
 1 ,   @ t i e n e d e s c u e n t o r e c a r s   o u t p u t ,   @ a p l i c a p o s f e c h a d o   o u t p u t ,   @ i m p o r t e a p l i c a d o   o u t p u t , 
 @ r e d o n d e o m o n e t a r i o s ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 i f   @ o k   i s   n u l l   a n d   @ c f g v a l i d a r p p m o r o s o s   =   1 
 i f   e x i s t s ( s e l e c t   *   f r o m   c x c d   w h e r e   i d   =   @ i d   a n d   i s n u l l ( d e s c u e n t o r e c a r s ,   0 )   <   0 . 0 ) 
 i f   e x i s t s ( s e l e c t   * 
 f r o m   c x c p e n d i e n t e   p   ,   m o v t i p o   m t   w h e r e   p . e m p r e s a   =   @ e m p r e s a 
 a n d   p . c l i e n t e   =   @ c o n t a c t o 
 a n d   m t . m o d u l o   =   ' c x c '   a n d   m t . m o v   =   p . m o v   a n d   m t . c l a v e   n o t   i n   ( ' c x c . a ' ,   ' c x c . a r ' ,   ' c x c . n c ' ,   ' c x c . n c d ' , ' c x c . n c f ' ) 
 a n d   i s n u l l ( p . d i a s m o r a t o r i o s ,   0 )   >   0 ) 
 s e l e c t   @ o k   =   6 5 0 9 0 
 e n d 
 i f   @ a p l i c a p o s f e c h a d o   =   1 
 b e g i n 
 i f   @ m o v t i p o   i n   ( ' c x c . c ' , ' c x p . p ' ) 
 b e g i n 
 i f   r o u n d ( @ i m p o r t e a p l i c a d o ,   @ r e d o n d e o m o n e t a r i o s ) < > r o u n d ( @ i m p o r t e t o t a l ,   @ r e d o n d e o m o n e t a r i o s )   s e l e c t   @ o k   =   3 0 2 3 0   e l s e 
 i f   @ m o d u l o   =   ' c x c '   i f   ( s e l e c t   c o u n t ( * )   f r o m   c x c d   w h e r e   i d   =   @ i d )   >   1   s e l e c t   @ o k   =   3 0 3 9 0   e l s e 
 i f   @ m o d u l o   =   ' c x p '   i f   ( s e l e c t   c o u n t ( * )   f r o m   c x p d   w h e r e   i d   =   @ i d )   >   1   s e l e c t   @ o k   =   3 0 3 9 0 
 e n d   e l s e 
 s e l e c t   @ o k   =   3 0 3 8 0 
 e n d 
 s e l e c t   @ f o r m a c o b r o t a r j e t a s   =   c x c f o r m a c o b r o t a r j e t a s   f r o m   e m p r e s a c f g   w h e r e   e m p r e s a   =   @ e m p r e s a 
 s e l e c t   @ t a r j e t a s c o b r a d a s   =   0 . 0 
 s e l e c t   @ c o n d e s g l o s e   =   c o n d e s g l o s e , 
 @ i m p o r t e 1   =   i s n u l l ( i m p o r t e 1 ,   0 ) ,   @ f o r m a c o b r o 1   =   f o r m a c o b r o 1 , 
 @ i m p o r t e 2   =   i s n u l l ( i m p o r t e 2 ,   0 ) ,   @ f o r m a c o b r o 2   =   f o r m a c o b r o 2 , 
 @ i m p o r t e 3   =   i s n u l l ( i m p o r t e 3 ,   0 ) ,   @ f o r m a c o b r o 3   =   f o r m a c o b r o 3 , 
 @ i m p o r t e 4   =   i s n u l l ( i m p o r t e 4 ,   0 ) ,   @ f o r m a c o b r o 4   =   f o r m a c o b r o 4 , 
 @ i m p o r t e 5   =   i s n u l l ( i m p o r t e 5 ,   0 ) ,   @ f o r m a c o b r o 5   =   f o r m a c o b r o 5 
 f r o m   c x c   w h e r e   i d   =   @ i d 
 i f   @ c o n d e s g l o s e   =   0   a n d   @ i m p o r t e t o t a l   >   0 . 0   a n d   @ f o r m a p a   =   @ f o r m a c o b r o t a r j e t a s 
 b e g i n 
 s e l e c t   @ t a r j e t a s c o b r a d a s   =   @ i m p o r t e t o t a l ,   @ f o r m a c o b r o 1   =   @ f o r m a p a 
 e n d 
 e l s e 
 b e g i n 
 i f   @ f o r m a c o b r o 1   =   @ f o r m a c o b r o t a r j e t a s   s e l e c t   @ t a r j e t a s c o b r a d a s   =   @ t a r j e t a s c o b r a d a s   +   @ i m p o r t e 1 
 i f   @ f o r m a c o b r o 2   =   @ f o r m a c o b r o t a r j e t a s   s e l e c t   @ t a r j e t a s c o b r a d a s   =   @ t a r j e t a s c o b r a d a s   +   @ i m p o r t e 2 
 i f   @ f o r m a c o b r o 3   =   @ f o r m a c o b r o t a r j e t a s   s e l e c t   @ t a r j e t a s c o b r a d a s   =   @ t a r j e t a s c o b r a d a s   +   @ i m p o r t e 3 
 i f   @ f o r m a c o b r o 4   =   @ f o r m a c o b r o t a r j e t a s   s e l e c t   @ t a r j e t a s c o b r a d a s   =   @ t a r j e t a s c o b r a d a s   +   @ i m p o r t e 4 
 i f   @ f o r m a c o b r o 5   =   @ f o r m a c o b r o t a r j e t a s   s e l e c t   @ t a r j e t a s c o b r a d a s   =   @ t a r j e t a s c o b r a d a s   +   @ i m p o r t e 5 
 e n d 
 i f   @ v a l e s c o b r a d o s   >   0 . 0   o r   @ t a r j e t a s c o b r a d a s   >   0 . 0 
 b e g i n 
 i f   @ m o v t i p o   i n   ( ' c x c . a ' ,   ' c x c . a r ' ,   ' c x c . a a ' ,   ' c x c . c ' ) 
 e x e c   s p v a l e v a l i d a r c o b r o   @ e m p r e s a ,   @ m o d u l o ,   @ i d ,   @ a c c i o n ,   @ f e c h a e m i s i o n ,   @ v a l e s c o b r a d o s ,   @ t a r j e t a s c o b r a d a s ,   @ m o v m o n e d a ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e l s e 
 s e l e c t   @ o k   =   3 6 1 0 0 ,   @ o k r e f   =   @ f o r m a p a 
 e n d 
 i f   @ m o v t i p o   i n   ( ' c x c . a ' , ' c x c . a r ' , ' c x c . a a ' , ' c x c . c ' )   a n d   u p p e r ( @ f o r m a p a )   =   u p p e r ( @ c f g f o r m a c o b r o d a )   a n d   @ a c c i o n   < >   ' c a n c e l a r '   a n d   @ c o n d e s g l o s e   =   0   a n d   @ o k   i s   n u l l 
 i f   ( s e l e c t   c x c d a r e f   f r o m   e m p r e s a c f g   w h e r e   e m p r e s a   =   @ e m p r e s a )   =   0 
 i f   n o t   e x i s t s   ( s e l e c t   *   f r o m   d i n e r o   w h e r e   e m p r e s a   =   @ e m p r e s a   a n d   e s t a t u s   =   ' p e n d i e n t e '   a n d   c t a d i n e r o   =   @ c t a d i n e r o   a n d   r o u n d ( i m p o r t e ,   @ r e d o n d e o m o n e t a r i o s )   =   r o u n d ( @ i m p o r t e t o t a l ,   @ r e d o n d e o m o n e t a r i o s )   a n d   m o n e d a   =   @ m o v m o n e d a ) 
 b e g i n 
 s e l e c t   @ o k r e f   =   n u l l 
 s e l e c t   @ o k r e f   =   m i n ( c t a d i n e r o )   f r o m   d i n e r o   w h e r e   e m p r e s a   =   @ e m p r e s a   a n d   e s t a t u s   =   ' p e n d i e n t e '   a n d   r o u n d ( i m p o r t e ,   @ r e d o n d e o m o n e t a r i o s )   =   r o u n d ( @ i m p o r t e t o t a l ,   @ r e d o n d e o m o n e t a r i o s )   a n d   m o n e d a   =   @ m o v m o n e d a 
 i f   @ o k r e f   i s   n u l l 
 s e l e c t   @ o k   =   3 5 1 6 0 
 e l s e   s e l e c t   @ o k   =   3 5 1 6 5 
 e n d 
 i f   @ m o v t i p o   i n   ( ' a g e n t . p ' , ' a g e n t . c o ' )   a n d   r o u n d ( @ i m p o r t e a p l i c a d o ,   @ r e d o n d e o m o n e t a r i o s )   <   0 . 0   s e l e c t   @ o k   =   3 0 1 0 0 
 e n d 
 i f   @ a c c i o n   n o t   i n   ( ' g e n e r a r ' ,   ' c a n c e l a r ' )   a n d   @ o k   i s   n u l l 
 e x e c   s p v a l i d a r m o v i m p o r t e m a x i m o   @ u s u a r i o ,   @ m o d u l o ,   @ m o v ,   @ i d ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 i f   @ o k   i s   n u l l 
 e x e c   x p c x v e r i f i c a r   @ i d ,   @ a c c i o n ,   @ e m p r e s a ,   @ u s u a r i o ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   @ m o v t i p o ,   @ m o v m o n e d a ,   @ m o v t i p o c a m b i o , 
 @ f e c h a e m i s i o n ,   @ c o n d i c i o n ,   @ v e n c i m i e n t o ,   @ f o r m a p a ,   @ c o n t a c t o ,   @ c o n t a c t o m o n e d a ,   @ c o n t a c t o f a c t o r ,   @ c o n t a c t o t i p o c a m b i o ,   @ i m p o r t e ,   @ i m p u e s t o s ,   @ s a l d o ,   @ c t a d i n e r o ,   @ a p l i c a m a n u a l ,   @ c o n d e s g l o s e , 
 @ c o b r o d e s g l o s a d o ,   @ c o b r o d e l e f e c t i v o ,   @ c o b r o c a m b i o , 
 @ i n d i r e c t o ,   @ c o n e x i o n ,   @ s i n c r o f i n a l ,   @ s u c u r s a l ,   @ e s t a t u s n u e v o ,   @ a f e c t a r c a n t i d a d p e n d i e n t e ,   @ a f e c t a r c a n t i d a d a ,   @ c f g c o n t x ,   @ c f g c o n t x g e n e r a r ,   @ c f g e m b a r c a r ,   @ a u t o a j u s t e ,   @ c f g f o r m a c o b r o d a ,   @ c f g r e f i n a n c i a m i e n t o t a s a , 
 @ m o v a p l i c a ,   @ m o v a p l i c a i d ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 r e t u r n 
 e n d 