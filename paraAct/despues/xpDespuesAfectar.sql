u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ x p d e s p u e s a f e c t a r ]   @ m o d u l o   c h a r ( 5 ) , 
 @ i d   i n t , 
 @ a c c i o n   c h a r ( 2 0 ) , 
 @ b a s e   c h a r ( 2 0 ) , 
 @ g e n e r a r m o v   c h a r ( 2 0 ) , 
 @ u s u a r i o   c h a r ( 1 0 ) , 
 @ s i n c r o f i n a l   b i t , 
 @ e n s i l e n c i o   b i t , 
 @ o k   i n t   o u t p u t , 
 @ o k r e f   v a r c h a r ( 2 5 5 )   o u t p u t , 
 @ f e c h a r e g i s t r o   d a t e t i m e 
 a s 
 b e g i n 
 d e c l a r e   @ m o v   v a r c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ c t e   v a r c h a r ( 1 0 ) , 
 @ c t e e n v i a r a   i n t , 
 @ s e e n v i a b u r o c t e   b i t , 
 @ s e e n v i a b u r o c a n a l   b i t , 
 @ e s t a t u s   v a r c h a r ( 1 5 ) , 
 @ c x i d   i n t , 
 @ d i n e r o i d   i n t , 
 @ o r i g e n c r i   v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d c r i   v a r c h a r ( 2 0 ) , 
 @ e s c r e d i l a n a   b i t , 
 @ m a y o r 1 2 m e s e s   b i t , 
 @ a p l i c a i d c t i   v a r c h a r ( 2 0 ) , 
 @ a p l i c a c t i   v a r c h a r ( 2 0 ) , 
 @ n u m e r o d o c u m e n t o s   i n t , 
 @ f i n a n c i a m i e n t o   m o n e y , 
 @ p e r s o n a l   v a r c h a r ( 1 0 ) , 
 @ d i n m o v i d   v a r c h a r ( 2 0 ) , 
 @ o r i g e n   v a r c h a r ( 2 0 ) , 
 @ c t a d i n e r o d i n   v a r c h a r ( 1 0 ) , 
 @ c t a d i n e r o d e s d i n   v a r c h a r ( 1 0 ) , 
 @ a p l i c a   v a r c h a r ( 2 0 ) , 
 @ a p l i c a i d   v a r c h a r ( 2 0 ) , 
 @ i d n c m o r   i n t , 
 @ m o v m o r   v a r c h a r ( 2 0 ) , 
 @ f e c h a c a n c e l a c i o n   d a t e t i m e , 
 @ m o v m o r i d   v a r c h a r ( 2 0 ) , 
 @ c o n c e p t o   v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d   i n t , 
 @ r e t e n c i o n c o n c e p t o   f l o a t , 
 @ i d p a d r e   i n t , 
 @ d a p l i c a   v a r c h a r ( 2 0 ) , 
 @ d a p l i c a i d   v a r c h a r ( 2 0 ) , 
 @ d p a d r e m a v i   v a r c h a r ( 2 0 ) , 
 @ d p a d r e i d m a v i   v a r c h a r ( 2 0 ) , 
 @ d f e c h a c o n c l u s i o n   d a t e t i m e , 
 @ d e s t a t u s   v a r c h a r ( 2 0 ) , 
 @ p a d r e i d   i n t , 
 @ d f e c h a e m i s i o n   d a t e t i m e , 
 @ i m p o r t e n c   f l o a t , 
 @ i d n c c o b r o   i n t , 
 @ c a n a l v e n t a   i n t , 
 @ o r i g e n p e d   v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d p e d   v a r c h a r ( 2 0 ) , 
 @ r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ r e f e r e n c i a m a v i   v a r c h a r ( 5 0 ) , 
 @ e n g a n c h e i d   i n t , 
 @ m o v f   v a r c h a r ( 2 0 ) , 
 @ m o v i d f   v a r c h a r ( 2 0 ) , 
 @ e m p r e s a   c h a r ( 5 ) , 
 @ s u c u r s a l   i n t , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ i d s o p o r t e   i n t , 
 @ i m p o r t e   m o n e y , 
 @ d o c s   i n t , 
 @ a b o n o   m o n e y , 
 @ f e c h a a s i g v a l e   d a t e , 
 @ d i a s p c d n   i n t 
 s e l e c t 
 @ f e c h a e m i s i o n   =   d b o . f n f e c h a s i n h o r a ( g e t d a t e ( ) ) 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 b e g i n 
 e x e c   s p a c t u a l i z a t i e m p o s m a v i   @ m o d u l o , 
 @ i d , 
 @ a c c i o n , 
 @ u s u a r i o 
 e n d 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 b e g i n 
 e x e c   s p a c t u a l i z a t i e m p o s m a v i   @ m o d u l o , 
 @ i d , 
 @ a c c i o n , 
 @ u s u a r i o 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o d u l o   =   ' v t a s ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ e s t a t u s   =   e s t a t u s , 
 @ c a n a l v e n t a   =   e n v i a r a , 
 @ c t e   =   c l i e n t e , 
 @ i m p o r t e   =   i m p o r t e   +   i m p u e s t o s , 
 @ d o c s   =   c o . d a n u m e r o d o c u m e n t o s   *   2 , 
 @ a b o n o   = 
 c a s e 
 w h e n   @ d o c s   >   0   t h e n   @ i m p o r t e   /   @ d o c s 
 e l s e   0 
 e n d 
 f r o m   v e n t a   v   w i t h   ( n o l o c k ) 
 i n n e r   j o i n   c o n d i c i o n   c o   w i t h   ( n o l o c k ) 
 o n   c o . c o n d i c i o n   =   v . c o n d i c i o n 
 w h e r e   i d   =   @ i d 
 e x e c   s p c l i e n t e s n u e v o s c a s a m a v i   @ m o d u l o , 
 @ i d , 
 @ a c c i o n 
 e x e c   s p g e n e r a r f i n a n c i a m i e n t o m a v i   @ i d , 
 ' v t a s ' 
 i f   @ m o v   i n   ( ' a n a l i s i s   c r e d i t o ' ,   ' p e d i d o ' ) 
 b e g i n 
 e x e c   x p a c t u a l i z a r e f a n t i c i p o   @ i d , 
 @ m o v 
 e n d 
 i f   d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' v t a s ' )   =   ' v t a s . f ' 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 b e g i n 
 s e t   @ c x i d   =   n u l l 
 s e l e c t 
 @ c x i d   =   c x c . i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 j o i n   c x c d   w i t h   ( n o l o c k ) 
 o n   c x c . i d   =   c x c d . i d 
 w h e r e   c x c d . a p l i c a   =   @ m o v 
 a n d   c x c d . a p l i c a i d   =   @ m o v i d 
 a n d   c x c . e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   c x c . m o v   =   ' a p l i c a c i o n   s a l d o ' 
 i f   @ c x i d   i s   n o t   n u l l 
 e x e c   x p d i s t r i b u y e s a l d o   @ c x i d 
 i f   @ c a n a l v e n t a   =   3 4 
 b e g i n 
 s e l e c t 
 @ p e r s o n a l   =   n o m i n a 
 f r o m   c t e e n v i a r a   c e   w i t h   ( n o l o c k ) 
 w h e r e   c l i e n t e   =   @ c t e 
 a n d   i d   =   3 4 
 i f   i s n u l l ( @ p e r s o n a l ,   ' ' )   >   ' ' 
 e x e c   c o m e r c i a l i z a d o r a . d b o . s p i d m 0 2 2 1 _ d e d u c c i o n c o m p r a s   @ c t e , 
 @ m o v , 
 @ m o v i d , 
 @ a b o n o , 
 @ p e r s o n a l , 
 @ d o c s 
 e n d 
 e n d 
 i f   @ m o v   i n   ( ' c a n c e l a   c r e d i l a n a ' ,   ' c a n c e l a   p r e s t a m o ' ) 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 b e g i n 
 s e l e c t 
 @ d i n e r o i d   =   n u l l 
 s e l e c t 
 @ d i n e r o i d   =   i d i n g r e s o m a v i 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   d i n e r o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ d i n e r o i d 
 a n d   e s t a t u s   =   ' s i n a f e c t a r ' ) 
 b e g i n 
 e x e c   s p a f e c t a r   ' d i n ' , 
 @ d i n e r o i d , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 n u l l , 
 @ u s u a r i o , 
 0 , 
 0 , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 n u l l , 
 0 , 
 n u l l 
 i f   ( s e l e c t 
 e s t a t u s 
 f r o m   d i n e r o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ d i n e r o i d ) 
 =   ' c o n c l u i d o ' 
 b e g i n 
 u p d a t e   d i n e r o   w i t h   ( r o w l o c k ) 
 s e t   r e f e r e n c i a   =   @ m o v   +   '   '   +   @ m o v i d 
 w h e r e   i d   =   @ d i n e r o i d 
 s e l e c t 
 @ o k   =   8 0 3 0 0 
 s e l e c t 
 @ o k r e f   =   m o v   +   '   '   +   m o v i d 
 f r o m   d i n e r o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ d i n e r o i d 
 e n d 
 e n d 
 e n d 
 e x e c   s p a c t u a l i z a d e s g l o s e   @ i d , 
 @ m o v , 
 ' ' , 
 ' c x c ' 
 d e c l a r e   @ c l a v e   v a r c h a r ( 1 0 ) 
 s e l e c t 
 @ c l a v e   =   c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   @ m o d u l o 
 a n d   m o v   =   @ m o v 
 i f   ( i s n u l l ( @ c l a v e ,   ' ' )   =   ' v t a s . f ' ) 
 b e g i n 
 i f   ( e x i s t s   ( s e l e c t   t o p   1 
 m o v 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   ' d o c u m e n t o ' 
 a n d   p a d r e m a v i   =   @ m o v 
 a n d   p a d r e i d m a v i   =   @ m o v i d 
 a n d   r e f e r e n c i a   < >   r e f e r e n c i a m a v i ) 
 ) 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   r e f e r e n c i a   =   r e f e r e n c i a m a v i 
 w h e r e   m o v   =   ' d o c u m e n t o ' 
 a n d   p a d r e m a v i   =   @ m o v 
 a n d   p a d r e i d m a v i   =   @ m o v i d 
 a n d   r e f e r e n c i a   < >   r e f e r e n c i a m a v i 
 e n d 
 i f   ( i s n u l l ( @ c l a v e ,   ' ' )   i n   ( ' v t a s . f ' ,   ' v t a s . d ' ) ) 
 b e g i n 
 e x e c   s p _ m a v i d m 0 2 7 9 c a l c u l a r b o n i f   @ m o v , 
 @ m o v i d , 
 @ i d , 
 0 , 
 @ c l a v e 
 e n d 
 i f   ( i s n u l l ( @ c l a v e ,   ' ' )   i n   ( ' v t a s . f ' ,   ' v t a s . p ' ) ) 
 b e g i n 
 e x e c   s p v t a s a c t u a l i z a e s t a t u s t a r j e t a   @ i d 
 e n d 
 i f   @ m o v   i n   ( s e l e c t   d i s t i n c t 
 m o v 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   c l a v e   =   ' v t a s . d ' ) 
 b e g i n 
 e x e c   s p d m 0 2 7 4 n o t a c d e v v e n t a   @ i d 
 e n d 
 e n d 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 a n d   @ m o d u l o   =   ' v t a s ' 
 a n d   ( s e l e c t 
 e n v i a r a 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d ) 
 =   3 4 
 a n d   ( s e l e c t 
 m . c l a v e 
 f r o m   v e n t a   v   w i t h   ( n o l o c k ) 
 j o i n   m o v t i p o   m   w i t h   ( n o l o c k ) 
 o n   m . m o v   =   v . m o v 
 a n d   m . m o d u l o   =   ' v t a s ' 
 w h e r e   v . i d   =   @ i d ) 
 =   ' v t a s . f ' 
 b e g i n 
 d e c l a r e   @ i d n o m   i n t 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ i d n o m   =   i d 
 f r o m   c o m e r c i a l i z a d o r a . d b o . n o m i n a   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   ' o t r a s   d e d u c c i o n e s ' 
 a n d   e s t a t u s   =   ' v i g e n t e ' 
 a n d   c o n c e p t o   i n   ( ' c p a   c r e d i l a n a ' ,   ' c p a   m e r c a n c i a ' ) 
 a n d   s u b s t r i n g ( r e p l a c e ( o b s e r v a c i o n e s ,   ' d e s c u e n t o   c o m p r a   ' ,   ' ' ) ,   1 , 
 c h a r i n d e x ( '   ' ,   r e p l a c e ( o b s e r v a c i o n e s ,   ' d e s c u e n t o   c o m p r a   ' ,   ' ' ) )   -   1 )   =   @ m o v 
 a n d   s u b s t r i n g ( r e p l a c e ( o b s e r v a c i o n e s ,   ' d e s c u e n t o   c o m p r a   ' ,   ' ' ) , 
 c h a r i n d e x ( '   ' ,   r e p l a c e ( o b s e r v a c i o n e s ,   ' d e s c u e n t o   c o m p r a   ' ,   ' ' ) )   +   1 , 
 d a t a l e n g t h ( r e p l a c e ( o b s e r v a c i o n e s ,   ' d e s c u e n t o   c o m p r a   ' ,   ' ' ) ) )   =   @ m o v i d 
 e x e c   c o m e r c i a l i z a d o r a . d b o . s p a f e c t a r   ' n o m ' , 
 @ i d n o m , 
 ' c a n c e l a r ' , 
 ' t o d o ' , 
 n u l l , 
 ' n o m i n 0 0 0 1 7 ' , 
 @ e s t a c i o n   =   9 9 
 e n d 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 a n d   @ m o d u l o   =   ' v t a s ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ e s t a t u s   =   e s t a t u s 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e x e c   s p e l i m i n a r r e c u p e r a c i o n m a v i   @ i d 
 d e c l a r e   @ c l a v e m o v   v a r c h a r ( 1 0 ) 
 s e l e c t 
 @ c l a v e m o v   =   d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' v t a s ' ) 
 i f   i s n u l l ( @ c l a v e m o v ,   ' ' )   =   ' v t a s . f ' 
 a n d   @ e s t a t u s   =   ' c a n c e l a d o ' 
 b e g i n 
 s e t   @ c x i d   =   n u l l 
 s e l e c t 
 @ c x i d   =   c x c . i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 j o i n   c x c d   w i t h   ( n o l o c k ) 
 o n   c x c . i d   =   c x c d . i d 
 w h e r e   c x c d . a p l i c a   =   @ m o v 
 a n d   c x c d . a p l i c a i d   =   @ m o v i d 
 a n d   c x c . e s t a t u s   =   ' c a n c e l a d o ' 
 a n d   c x c . m o v   =   ' a p l i c a c i o n   s a l d o ' 
 i f   @ c x i d   i s   n o t   n u l l 
 e x e c   x p d i s t r i b u y e s a l d o c a n c e l a r m a v i   @ c x i d 
 e n d 
 s e l e c t 
 @ c l a v e   =   c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   @ m o d u l o 
 a n d   m o v   =   @ m o v 
 i f   i s n u l l ( @ c l a v e m o v ,   ' ' )   =   ' v t a s . d ' 
 e x e c   s p _ m a v i d m 0 2 7 9 c a l c u l a r b o n i f   @ m o v , 
 @ m o v i d , 
 @ i d , 
 0 , 
 @ c l a v e m o v 
 i f   ( i s n u l l ( @ c l a v e ,   ' ' )   i n   ( ' v t a s . f ' ,   ' v t a s . p ' ) ) 
 b e g i n 
 e x e c   s p v t a s a c t u a l i z a e s t a t u s t a r j e t a   @ i d 
 e n d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 e x e c   s p a c t u a l i z a r p r o g r a m a r e c u p e r a c i o n m a v i   @ i d 
 e x e c   s p a p o y o f a c t o r i m m a v i   @ i d 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ e s t a t u s   =   e s t a t u s , 
 @ f i n a n c i a m i e n t o   =   f i n a n c i a m i e n t o , 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   ( s e l e c t 
 c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v ) 
 =   ' c x c . c ' 
 b e g i n 
 s e l e c t 
 @ d f e c h a c o n c l u s i o n   =   f e c h a c o n c l u s i o n , 
 @ d e s t a t u s   =   e s t a t u s 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 d e c l a r e   @ p a d r e s c o b r a d o s   t a b l e   ( 
 i d t m p   i n t   i d e n t i t y   p r i m a r y   k e y , 
 i d   i n t , 
 p a d r e m a v i   v a r c h a r ( 2 0 ) , 
 p a d r e i d m a v i   v a r c h a r ( 2 0 ) , 
 i m p o r t e   f l o a t 
 ) 
 i n s e r t   i n t o   @ p a d r e s c o b r a d o s 
 s e l e c t 
 f . i d , 
 f . m o v , 
 f . m o v i d , 
 s u m ( d . i m p o r t e ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c   c   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c . m o v 
 a n d   d . a p l i c a i d   =   c . m o v i d 
 j o i n   c x c   f   w i t h   ( n o l o c k ) 
 o n   c . p a d r e m a v i   =   f . m o v 
 a n d   c . p a d r e i d m a v i   =   f . m o v i d 
 w h e r e   d . i d   =   @ i d 
 g r o u p   b y   f . i d , 
 f . m o v , 
 f . m o v i d 
 i n s e r t   i n t o   c o b r o s x p a d r e 
 s e l e c t 
 p . i d , 
 @ i d , 
 @ d f e c h a c o n c l u s i o n , 
 p . i m p o r t e , 
 @ d e s t a t u s , 
 ' c x c . c ' 
 f r o m   @ p a d r e s c o b r a d o s   p 
 e n d 
 i f   ( s e l e c t 
 c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v ) 
 =   ' c x c . c a ' 
 a n d   @ c o n c e p t o   l i k e   ' c a n c   c o b r o % ' 
 b e g i n 
 s e l e c t 
 @ d p a d r e m a v i   =   p a d r e m a v i , 
 @ d p a d r e i d m a v i   =   p a d r e i d m a v i , 
 @ d f e c h a e m i s i o n   =   f e c h a e m i s i o n , 
 @ m o v   =   m o v , 
 @ i m p o r t e n c   =   i s n u l l ( i m p o r t e ,   0 )   +   i s n u l l ( i m p u e s t o s ,   0 ) , 
 @ d e s t a t u s   =   e s t a t u s 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ p a d r e i d   =   i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ d p a d r e m a v i 
 a n d   m o v i d   =   @ d p a d r e i d m a v i 
 s e l e c t 
 @ i d n c c o b r o   =   ( s u b s t r i n g ( s u b s t r i n g ( v a l o r ,   ( c h a r i n d e x ( ' _ ' ,   v a l o r )   +   1 ) ,   l e n ( v a l o r ) ) , 
 c h a r i n d e x ( ' _ ' ,   ( s u b s t r i n g ( v a l o r ,   ( c h a r i n d e x ( ' _ ' ,   v a l o r )   +   1 ) ,   l e n ( v a l o r ) ) ) )   +   1 , 
 l e n ( s u b s t r i n g ( v a l o r ,   ( c h a r i n d e x ( ' _ ' ,   v a l o r )   +   1 ) ,   l e n ( v a l o r ) ) ) ) ) 
 f r o m   m o v c a m p o e x t r a   w i t h   ( n o l o c k ) 
 w h e r e   c a m p o e x t r a   i n   ( ' n c _ c o b r o ' ,   ' n c v _ c o b r o ' ,   ' n c m _ c o b r o ' ) 
 a n d   i d   =   @ i d 
 a n d   m o v   =   @ m o v 
 i f   @ i d n c c o b r o   i s   n o t   n u l l 
 i n s e r t   i n t o   n c a r c c x p a d r e 
 s e l e c t 
 @ p a d r e i d , 
 @ i d n c c o b r o , 
 @ i d , 
 @ d f e c h a e m i s i o n , 
 @ i m p o r t e n c , 
 @ d e s t a t u s 
 s e l e c t 
 @ i d p a d r e   =   i d p a d r e 
 f r o m   d b o . n c a r c c x p a d r e   w i t h   ( n o l o c k ) 
 w h e r e   i d n c a r   =   @ i d 
 i f   ( s e l e c t 
 c o u n t ( * ) 
 f r o m   c o b r o s x p a d r e   w i t h   ( n o l o c k ) 
 w h e r e   i d p a d r e   =   @ i d p a d r e 
 a n d   e s t a t u s   =   ' c o n c l u i d o ' ) 
 =   1 
 b e g i n 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   c a l i f i c a c i o n m a v i   =   0 , 
 p o n d e r a c i o n c a l i f m a v i   =   ' * ' 
 w h e r e   i d   =   @ i d p a d r e 
 u p d a t e   c x c m a v i   w i t h   ( r o w l o c k ) 
 s e t   m o p m a v i   =   0 , 
 m o p a c t m a v i   =   n u l l , 
 f e c h a u l t a b o n o   =   n u l l 
 w h e r e   i d   =   @ i d p a d r e 
 d e l e t e   d b o . h i s t o r i c o m o p m a v i 
 w h e r e   i d   =   @ i d p a d r e 
 e n d 
 e x e c   s p _ m a v i d m 0 2 7 9 c a l c u l a r b o n i f   @ m o v , 
 @ m o v i d , 
 0 , 
 @ i d , 
 ' c x c . c a ' 
 e n d 
 i f   ( s e l e c t 
 c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v ) 
 =   ' c x c . n c ' 
 a n d   @ c o n c e p t o   l i k e   ' c o r r   c o b r o % ' 
 b e g i n 
 s e l e c t   t o p   1 
 @ d a p l i c a   =   a p l i c a , 
 @ d a p l i c a i d   =   a p l i c a i d 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ d f e c h a e m i s i o n   =   f e c h a e m i s i o n , 
 @ d e s t a t u s   =   e s t a t u s 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ d p a d r e m a v i   =   p a d r e m a v i , 
 @ d p a d r e i d m a v i   =   p a d r e i d m a v i 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ d a p l i c a 
 a n d   m o v i d   =   @ d a p l i c a i d 
 s e l e c t 
 @ p a d r e i d   =   i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ d p a d r e m a v i 
 a n d   m o v i d   =   @ d p a d r e i d m a v i 
 i n s e r t   i n t o   c o b r o s x p a d r e 
 s e l e c t 
 @ p a d r e i d , 
 @ i d , 
 @ d f e c h a e m i s i o n , 
 s u m ( i s n u l l ( i m p o r t e ,   0 ) ) , 
 @ d e s t a t u s , 
 ' c x c . n c ' 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e n d 
 i f   ( @ m o v   i n   ( ' e n d o s o ' ) ) 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ c t e   =   c l i e n t e , 
 @ c t e e n v i a r a   =   c l i e n t e e n v i a r a 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ s e e n v i a b u r o c t e   =   s e e n v i a b u r o c r e d i t o m a v i 
 f r o m   c t e e n v i a r a   w i t h   ( n o l o c k ) 
 w h e r e   c l i e n t e   =   @ c t e 
 a n d   i d   =   @ c t e e n v i a r a 
 s e l e c t 
 @ s e e n v i a b u r o c a n a l   =   s e e n v i a b u r o c r e d i t o m a v i 
 f r o m   v e n t a s c a n a l m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ c t e e n v i a r a 
 i f   ( @ s e e n v i a b u r o c t e   =   1 ) 
 e x e c   s p c a m b i a r c x c b u r o c a n a l v e n t a   @ m o v , 
 @ m o v i d 
 e n d 
 i f   ( @ m o v   i n   ( ' c t a   i n c o b r a b l e   f ' ,   ' c t a   i n c o b r a b l e   n v ' ) ) 
 b e g i n 
 e x e c   s p d e s a c t i v a e n v i a r b u r o f a c t e n c t a i n c   @ i d 
 i f   ( @ e s t a t u s   =   ' p e n d i e n t e ' ) 
 e x e c   s p a c t u a l i z a c t a i n c m i g r a m a v i c o b   @ i d 
 e n d 
 i f   d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' c x c ' )   i n   ( ' c x c . d e ' ) 
 b e g i n 
 e x e c   x p d e v o l u c i o n a n t i c i p o s a l d o m a v i   @ i d , 
 @ u s u a r i o 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   r e f e r e n c i a   =   r e f a n t i c i p o m a v i 
 w h e r e   i d   =   @ i d 
 e n d 
 i f   ( @ m o v   i n   ( ' c o n t r a   r e c i b o   i n s t ' ) ) 
 b e g i n 
 s e l e c t 
 @ o r i g e n c r i   =   o r i g e n , 
 @ o r i g e n i d c r i   =   o r i g e n i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ e s c r e d i l a n a   =   e s c r e d i l a n a , 
 @ m a y o r 1 2 m e s e s   =   m a y o r 1 2 m e s e s 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ o r i g e n c r i 
 a n d   m o v i d   =   @ o r i g e n i d c r i 
 a n d   e s t a t u s   i n   ( ' c o n c l u i d o ' ,   ' p e n d i e n t e ' ) 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   e s c r e d i l a n a   =   @ e s c r e d i l a n a , 
 m a y o r 1 2 m e s e s   =   @ m a y o r 1 2 m e s e s 
 w h e r e   i d   =   @ i d 
 e n d 
 i f   ( @ m o v   i n   ( ' c t a   i n c o b r a b l e   n v ' ,   ' c t a   i n c o b r a b l e   f ' ) ) 
 b e g i n 
 s e l e c t 
 @ a p l i c a c t i   =   a p l i c a , 
 @ a p l i c a i d c t i   =   m i n ( a p l i c a i d ) 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 g r o u p   b y   a p l i c a 
 s e l e c t 
 @ e s c r e d i l a n a   =   e s c r e d i l a n a , 
 @ m a y o r 1 2 m e s e s   =   m a y o r 1 2 m e s e s 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ a p l i c a c t i 
 a n d   m o v i d   =   @ a p l i c a i d c t i 
 a n d   e s t a t u s   i n   ( ' c o n c l u i d o ' ,   ' p e n d i e n t e ' ) 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   e s c r e d i l a n a   =   @ e s c r e d i l a n a , 
 m a y o r 1 2 m e s e s   =   @ m a y o r 1 2 m e s e s 
 w h e r e   i d   =   @ i d 
 e n d 
 i f   ( @ m o v   i n   ( ' a n t i c i p o   c o n t a d o ' ,   ' a n t i c i p o   m a y o r e o ' , 
 ' a p a r t a d o ' ,   ' e n g a n c h e ' ,   ' d e v o l u c i o n ' , 
 ' d e v   a n t i c i p o   c o n t a d o ' ,   ' d e v   a n t i c i p o   m a y o r e o ' , 
 ' d e v o l u c i o n   e n g a n c h e ' ,   ' d e v o l u c i o n   a p a r t a d o ' ) ) 
 e x e c   s p m a y o r 1 2 a n t i c i p o d e v   @ i d 
 i f   @ m o v   =   ' r e f i n a n c i a m i e n t o ' 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 b e g i n 
 e x e c   s p g e n e r a r f i n a n c i a m i e n t o m a v i   @ i d , 
 ' c x c ' 
 s e l e c t 
 @ n u m e r o d o c u m e n t o s   =   0 
 e x e c   s p p r e n d e m a y o r 1 2 m a v i   @ i d 
 e x e c   s p p r e n d e b i t s m a v i   @ i d 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   r e f e r e n c i a   =   @ m o v   +   '   '   +   @ m o v i d 
 w h e r e   i d   i n   ( s e l e c t 
 i d c x c 
 f r o m   r e f i n i d i n v o l u c r a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d ) 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   c o n c e p t o   =   ' r e f i n a n c i a m i e n t o ' 
 w h e r e   r e f e r e n c i a   =   @ m o v   +   '   '   +   @ m o v i d 
 a n d   m o v   =   ' n o t a   c a r ' 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 s e l e c t 
 @ n u m e r o d o c u m e n t o s   =   n u m e r o d o c u m e n t o s 
 f r o m   d o c a u t o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 i f   i s n u l l ( @ n u m e r o d o c u m e n t o s ,   0 )   >   0 
 b e g i n 
 s e l e c t 
 @ f i n a n c i a m i e n t o   =   @ f i n a n c i a m i e n t o 
 /   @ n u m e r o d o c u m e n t o s 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   f i n a n c i a m i e n t o   =   @ f i n a n c i a m i e n t o 
 w h e r e   o r i g e n   =   @ m o v 
 a n d   o r i g e n i d   =   @ m o v i d 
 a n d   m o v   =   ' d o c u m e n t o ' 
 a n d   e s t a t u s   =   ' p e n d i e n t e ' 
 e n d 
 e n d 
 i f   @ m o v   =   ' r e f i n a n c i a m i e n t o ' 
 a n d   @ e s t a t u s   =   ' p e n d i e n t e ' 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   r e f e r e n c i a   =   @ m o v   +   '   '   +   @ m o v i d 
 w h e r e   i d   i n   ( s e l e c t 
 i d c x c 
 f r o m   r e f i n i d i n v o l u c r a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d ) 
 e x e c   s p a c t u a l i z a d e s g l o s e   @ i d , 
 ' ' , 
 ' ' , 
 ' c x c ' 
 i f   @ m o v   i n   ( ' n o t a   c a r ' ,   ' n o t a   c a r   v i u ' , 
 ' n o t a   c a r   m a y o r e o ' ) 
 b e g i n 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   f e c h a o r i g i n a l   =   v e n c i m i e n t o 
 w h e r e   i d   =   @ i d 
 e n d 
 i f   @ m o v   i n   ( ' n o t a   c r e d i t o ' ,   ' n o t a   c r e d i t o   v i u ' , 
 ' n o t a   c r e d i t o   m a y o r e o ' ,   ' c a n c e l a   p r e s t a m o ' ,   ' c a n c e l a   c r e d i l a n a ' ) 
 a n d   @ c o n c e p t o   l i k e   ' c o r r   c o b r o % ' 
 b e g i n 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   n o t a   =   ( s e l e c t   t o p   1 
 p a d r e . i d 
 f r o m   c x c   c   w i t h   ( n o l o c k ) 
 j o i n   c x c d   d   w i t h   ( n o l o c k ) 
 o n   d . i d   =   c . i d 
 j o i n   c x c   f   w i t h   ( n o l o c k ) 
 o n   f . m o v   =   d . a p l i c a 
 a n d   f . m o v i d   =   d . a p l i c a i d 
 j o i n   c x c   p a d r e   w i t h   ( n o l o c k ) 
 o n   p a d r e . m o v   =   f . p a d r e m a v i 
 a n d   p a d r e . m o v i d   =   f . p a d r e i d m a v i 
 w h e r e   c . i d   =   @ i d ) 
 w h e r e   i d   =   @ i d 
 e n d 
 e n d 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 a n d   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 e x e c   s p a c t u a l i z a r p r o g r a m a r e c u p e r a c i o n a l c a n c e l a r m a v i   @ i d 
 s e l e c t 
 @ m o v   =   m o v , 
 @ e s t a t u s   =   e s t a t u s , 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   ( s e l e c t 
 c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v ) 
 =   ' c x c . a n c ' 
 a n d   @ c o n c e p t o   l i k e   ' c o r r   c o b r o % ' 
 u p d a t e   c o b r o s x p a d r e   w i t h   ( r o w l o c k ) 
 s e t   e s t a t u s   =   ' c a n c e l a d o ' 
 w h e r e   i d c o b r o   =   @ i d 
 i f   ( s e l e c t 
 c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v ) 
 =   ' c x c . n c ' 
 a n d   @ c o n c e p t o   l i k e   ' c o r r   c o b r o % ' 
 u p d a t e   c o b r o s x p a d r e   w i t h   ( r o w l o c k ) 
 s e t   e s t a t u s   =   ' c a n c e l a d o ' 
 w h e r e   i d c o b r o   =   @ i d 
 i f   @ m o v   l i k e   ' c o b r o % ' 
 u p d a t e   c o b r o s x p a d r e   w i t h   ( r o w l o c k ) 
 s e t   e s t a t u s   =   ' c a n c e l a d o ' 
 w h e r e   i d c o b r o   =   @ i d 
 i f   ( s e l e c t 
 c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' c x c ' 
 a n d   m o v   =   @ m o v ) 
 =   ' c x c . c a ' 
 a n d   @ c o n c e p t o   l i k e   ' c a n c   c o b r o % ' 
 u p d a t e   n c a r c c x p a d r e   w i t h   ( r o w l o c k ) 
 s e t   e s t a t u s n c a r   =   ' c a n c e l a d o ' 
 w h e r e   i d n c a r   =   @ i d 
 i f   ( @ m o v   i n   ( ' c t a   i n c o b r a b l e   f ' ,   ' c t a   i n c o b r a b l e   n v ' ) ) 
 e x e c   s p a c t i v a e n v i a r b u r o f a c t e n c t a i n c   @ i d 
 i f   d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' c x c ' )   i n   ( ' c x c . a a ' ) 
 a n d   @ e s t a t u s   =   ' c a n c e l a d o ' 
 b e g i n 
 e x e c   x p c a n c e l a e n g a n c h e   @ i d , 
 @ u s u a r i o 
 e n d 
 i f   d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' c x c ' )   i n   ( ' c x c . d e ' ) 
 b e g i n 
 e x e c   x p c a n c e l a d e v o l u c i o n   @ i d 
 e n d 
 i f   @ m o v   i n   ( ' n o t a   c a r ' ,   ' n o t a   c a r   v i u ' , 
 ' n o t a   c a r   m a y o r e o ' ,   ' n o t a   c r e d i t o ' , 
 ' n o t a   c r e d i t o   v i u ' ,   ' n o t a   c r e d i t o   m a y o r e o ' ) 
 a n d   @ e s t a t u s   =   ' c a n c e l a d o ' 
 b e g i n 
 i f   e x i s t s   ( s e l e c t 
 m o d u l o i d 
 f r o m   c f d   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o i d   =   @ i d ) 
 b e g i n 
 s e l e c t 
 @ f e c h a c a n c e l a c i o n   =   f e c h a c a n c e l a c i o n 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 u p d a t e   c f d   w i t h   ( r o w l o c k ) 
 s e t   f e c h a c a n c e l a c i o n   =   @ f e c h a c a n c e l a c i o n 
 w h e r e   m o d u l o i d   =   @ i d 
 e n d 
 e n d 
 i f   ( d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' c x c ' )   =   ' c x c . d m ' ) 
 a n d   @ a c c i o n   =   ' c a n c e l a r ' 
 a n d   @ o k   i s   n u l l 
 e x e c   s p r e v i s a c t a i n c e n v i o m a v i c o b   @ i d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o d u l o   =   ' a f ' 
 b e g i n 
 e x e c   s p a c t u a l i z a r s e r v i c i o a f a l a f e c t a r m a v i   @ i d 
 e n d 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 a n d   @ m o d u l o   =   ' a f ' 
 b e g i n 
 e x e c   s p a c t u a l i z a r s e r v i c i o a f a l c a n c e l a r m a v i   @ i d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o d u l o   =   ' g a s ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d 
 f r o m   g a s t o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' c a r   b a n c a r i o ' 
 u p d a t e   g a s t o   w i t h   ( r o w l o c k ) 
 s e t   g e n e r a r d i n e r o   =   0 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' c o n t r a t o ' 
 b e g i n 
 e x e c   s p s o l g a s t o c o n t r a t o d f   @ i d 
 u p d a t e   g a s t o   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   f e c h a r e q u e r i d a 
 w h e r e   o r i g e n   =   @ m o v 
 a n d   o r i g e n i d   =   @ m o v i d 
 e n d 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d 
 f r o m   g a s t o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ o r i g e n i d   =   i d 
 f r o m   c x p   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 i f   @ m o v   =   ' g a s t o ' 
 b e g i n 
 i f   ( e x i s t s   ( s e l e c t 
 r e t e n c i o n 2 
 f r o m   m o v i m p u e s t o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' g a s ' 
 a n d   m o d u l o i d   =   @ i d 
 a n d   r e t e n c i o n 2   >   9 ) 
 ) 
 b e g i n 
 s e l e c t   d i s t i n c t 
 @ r e t e n c i o n c o n c e p t o   =   r e t e n c i o n 2 
 f r o m   c o n c e p t o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' g a s ' 
 a n d   r e t e n c i o n 2   >   9 
 u p d a t e   m o v i m p u e s t o   w i t h   ( r o w l o c k ) 
 s e t   r e t e n c i o n 2   =   @ r e t e n c i o n c o n c e p t o 
 w h e r e   m o d u l o   =   ' g a s ' 
 a n d   m o d u l o i d   =   @ i d 
 a n d   r e t e n c i o n 2   >   9 
 u p d a t e   m o v i m p u e s t o   w i t h   ( r o w l o c k ) 
 s e t   r e t e n c i o n 2   =   @ r e t e n c i o n c o n c e p t o 
 w h e r e   m o d u l o   =   ' c x p ' 
 a n d   m o d u l o i d   =   @ o r i g e n i d 
 a n d   r e t e n c i o n 2   >   9 
 e n d 
 e n d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o d u l o   =   ' e m b ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ e s t a t u s   =   e s t a t u s 
 f r o m   e m b a r q u e   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' e m b a r q u e ' 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 u p d a t e   e m b a r q u e d   w i t h   ( r o w l o c k ) 
 s e t   p a r a c o m i s i o n c h o f e r m a v i   =   1 
 w h e r e   e s t a d o   =   ' e n t r e g a d o ' 
 a n d   i d   =   @ i d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o d u l o   =   ' a f ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ p e r s o n a l   =   p e r s o n a l 
 f r o m   a c t i v o f i j o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' a s i g n a c i o n ' 
 b e g i n 
 u p d a t e   p e r s o n a l   w i t h   ( r o w l o c k ) 
 s e t   a f c o m e r   =   1 
 w h e r e   p e r s o n a l   =   @ p e r s o n a l 
 e n d 
 i f   @ m o v   =   ' d e v o l u c i o n ' 
 b e g i n 
 u p d a t e   p e r s o n a l   w i t h   ( r o w l o c k ) 
 s e t   a f c o m e r   =   0 
 w h e r e   p e r s o n a l   =   @ p e r s o n a l 
 e n d 
 e n d 
 i f   @ m o d u l o   =   ' d i n ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ d i n m o v i d   =   m o v i d , 
 @ e s t a t u s   =   e s t a t u s , 
 @ o r i g e n   =   o r i g e n , 
 @ c t a d i n e r o d i n   =   c t a d i n e r o , 
 @ c t a d i n e r o d e s d i n   =   c t a d i n e r o d e s t i n o 
 f r o m   d i n e r o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' i n g r e s o ' 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 b e g i n 
 i n s e r t   i n t o   m o v f l u j o   ( s u c u r s a l , 
 e m p r e s a , 
 o m o d u l o , 
 o i d , 
 o m o v , 
 o m o v i d , 
 d m o d u l o , 
 d i d , 
 d m o v , 
 d m o v i d , 
 c a n c e l a d o ) 
 s e l e c t 
 c . s u c u r s a l , 
 ' m a v i ' , 
 ' c x c ' , 
 c . i d , 
 c . m o v , 
 c . m o v i d , 
 ' d i n ' , 
 a . i d , 
 a . m o v , 
 a . m o v i d , 
 0 
 f r o m   d i n e r o   a   w i t h   ( n o l o c k ) , 
 v e n t a   b   w i t h   ( n o l o c k ) , 
 c x c   c   w i t h   ( n o l o c k ) 
 w h e r e   a . i d   =   @ i d 
 a n d   a . i d   =   b . i d i n g r e s o m a v i 
 a n d   b . m o v   =   c . o r i g e n 
 a n d   b . m o v i d   =   c . o r i g e n i d 
 i f   @ o r i g e n   i s   n u l l 
 b e g i n 
 u p d a t e   d i n e r o   w i t h   ( r o w l o c k ) 
 s e t   d i n e r o . o r i g e n t i p o   =   ' c x c ' , 
 d i n e r o . o r i g e n   =   m o v f l u j o . o m o v , 
 d i n e r o . o r i g e n i d   =   m o v f l u j o . o m o v i d 
 f r o m   m o v f l u j o   w i t h   ( n o l o c k ) 
 w h e r e   d i n e r o . m o v   =   ' i n g r e s o ' 
 a n d   m o v f l u j o . d m o d u l o   =   ' d i n ' 
 a n d   d i n e r o . i d   =   m o v f l u j o . d i d 
 a n d   d i n e r o . m o v   =   m o v f l u j o . d m o v 
 a n d   d i n e r o . m o v i d   =   m o v f l u j o . d m o v i d 
 a n d   d i n e r o . i d   =   @ i d 
 e n d 
 e n d 
 i f   @ e s t a t u s   =   ' c o n c l u i d o ' 
 b e g i n 
 i f   @ m o v   =   ' a p e r t u r a   c a j a ' 
 b e g i n 
 u p d a t e   c t a d i n e r o   w i t h   ( r o w l o c k ) 
 s e t   e s t a d o   =   1 
 w h e r e   c t a d i n e r o   =   @ c t a d i n e r o d e s d i n 
 e n d 
 i f   @ m o v   =   ' c o r t e   c a j a ' 
 b e g i n 
 u p d a t e   c t a d i n e r o   w i t h   ( r o w l o c k ) 
 s e t   e s t a d o   =   0 
 w h e r e   c t a d i n e r o   =   @ c t a d i n e r o d i n 
 e n d 
 e n d 
 i f   @ e s t a t u s   =   ' c a n c e l a d o ' 
 b e g i n 
 i f   @ m o v   =   ' a p e r t u r a   c a j a ' 
 b e g i n 
 u p d a t e   c t a d i n e r o   w i t h   ( r o w l o c k ) 
 s e t   e s t a d o   =   0 
 w h e r e   c t a d i n e r o   =   @ c t a d i n e r o d e s d i n 
 e n d 
 i f   @ m o v   =   ' c o r t e   c a j a ' 
 b e g i n 
 u p d a t e   c t a d i n e r o   w i t h   ( r o w l o c k ) 
 s e t   e s t a d o   =   1 
 w h e r e   c t a d i n e r o   =   @ c t a d i n e r o d i n 
 e n d 
 e n d 
 e n d 
 i f   @ m o d u l o   =   ' c x c ' 
 a n d   d b o . f n c l a v e a f e c t a c i o n m a v i ( @ m o v ,   ' c x c ' )   i n   ( ' c x c . c ' ) 
 a n d   @ e s t a t u s   =   ' c a n c e l a d o ' 
 b e g i n 
 d e c l a r e   c 2   c u r s o r   f a s t _ f o r w a r d   f o r 
 s e l e c t 
 a p l i c a , 
 a p l i c a i d 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 a n d   a p l i c a   i n   ( ' n o t a   c a r ' ,   ' n o t a   c a r   v i u ' ,   ' n o t a   c a r   m a y o r e o ' ) 
 o p e n   c 2 
 f e t c h   n e x t   f r o m   c 2   i n t o   @ a p l i c a ,   @ a p l i c a i d 
 w h i l e   @ @ f e t c h _ s t a t u s   =   0 
 b e g i n 
 s e l e c t 
 @ i d n c m o r   =   i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ a p l i c a 
 a n d   m o v i d   =   @ a p l i c a i d 
 d e c l a r e   c r c a n c e l n c   c u r s o r   f a s t _ f o r w a r d   f o r 
 s e l e c t 
 o r i g e n , 
 o r i g e n i d 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   n o t a c a r m o r i d   =   @ i d n c m o r 
 g r o u p   b y   o r i g e n , 
 o r i g e n i d 
 o p e n   c r c a n c e l n c 
 f e t c h   n e x t   f r o m   c r c a n c e l n c   i n t o   @ m o v m o r ,   @ m o v m o r i d 
 w h i l e   @ @ f e t c h _ s t a t u s   =   0 
 b e g i n 
 e x e c   s p a f e c t a r   ' c x c ' , 
 @ i d n c m o r , 
 ' c a n c e l a r ' , 
 ' t o d o ' , 
 n u l l , 
 @ u s u a r i o , 
 n u l l , 
 0 , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 n u l l , 
 @ c o n e x i o n   =   0 
 f e t c h   n e x t   f r o m   c r c a n c e l n c   i n t o   @ m o v m o r ,   @ m o v m o r i d 
 e n d 
 c l o s e   c r c a n c e l n c 
 d e a l l o c a t e   c r c a n c e l n c 
 f e t c h   n e x t   f r o m   c 2   i n t o   @ a p l i c a ,   @ a p l i c a i d 
 e n d 
 c l o s e   c 2 
 d e a l l o c a t e   c 2 
 e n d 
 i f   d b _ n a m e ( )   ! =   ' m a v i c o b ' 
 b e g i n 
 i f   @ m o d u l o   =   ' c x c ' 
 a n d   i s n u l l ( @ a c c i o n ,   ' ' )   i n   ( ' c a n c e l a r ' ,   ' a f e c t a r ' ) 
 a n d   i s n u l l ( @ o k ,   0 )   =   0 
 a n d   e x i s t s   ( s e l e c t 
 i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 a n d   m o v   i n   ( s e l e c t   d i s t i n c t 
 m o v c a r 
 f r o m   t c i d m 0 2 2 4 _ c o n f i g n o t a s e s p e j o   w i t h   ( n o l o c k ) 
 u n i o n   a l l 
 s e l e c t   d i s t i n c t 
 m o v c r e d i t o 
 f r o m   t c i d m 0 2 2 4 _ c o n f i g n o t a s e s p e j o   w i t h   ( n o l o c k ) ) 
 a n d   i s n u l l ( c o n c e p t o ,   ' ' )   i n   ( s e l e c t   d i s t i n c t 
 c o n c e p t o c a r 
 f r o m   t c i d m 0 2 2 4 _ c o n f i g n o t a s e s p e j o   w i t h   ( n o l o c k ) 
 u n i o n   a l l 
 s e l e c t   d i s t i n c t 
 c o n c e p t o c r e d i t o 
 f r o m   t c i d m 0 2 2 4 _ c o n f i g n o t a s e s p e j o   w i t h   ( n o l o c k ) ) 
 a n d   e s t a t u s   n o t   i n   ( ' c a n c e l a d o ' ,   ' s i n a f e c t a r ' ) ) 
 b e g i n 
 e x e c   d b o . s p _ m a v i d m 0 2 2 4 n o t a c r e d i t o e s p e j o   @ i d , 
 @ a c c i o n , 
 @ u s u a r i o , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 ' d e s p u e s ' 
 e n d 
 i f   @ m o d u l o   =   ' c x c ' 
 a n d   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ e s t a t u s   =   e s t a t u s , 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 a p l i c a , 
 a p l i c a i d 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d ) 
 b e g i n 
 s e l e c t 
 @ a p l i c a   =   a p l i c a , 
 @ a p l i c a i d   =   a p l i c a i d 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 j o i n   c o n d i c i o n   c o   w i t h   ( n o l o c k ) 
 o n   c x c . c o n d i c i o n   =   c o . c o n d i c i o n 
 w h e r e   m o v   =   @ a p l i c a 
 a n d   m o v i d   =   @ a p l i c a i d 
 a n d   d b o . f n c l a v e a f e c t a c i o n m a v i ( m o v ,   ' v t a s ' )   =   ' v t a s . f ' 
 a n d   e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   s a l d o   =   n u l l 
 a n d   c o . t i p o c o n d i c i o n   =   ' c o n t a d o ' 
 a n d   c o . g r u p o   =   ' m e n u d e o ' ) 
 b e g i n 
 s e l e c t 
 @ o r i g e n i d   =   v . i d , 
 @ m o v f   =   c c . m o v , 
 @ m o v i d f   =   c c . m o v i d , 
 @ e m p r e s a   =   v . e m p r e s a , 
 @ s u c u r s a l   =   v . s u c u r s a l 
 f r o m   v e n t a   v   w i t h   ( n o l o c k ) 
 j o i n   c x c   c c   w i t h   ( n o l o c k ) 
 o n   v . m o v   =   c c . m o v 
 a n d   v . m o v i d   =   c c . m o v i d 
 w h e r e   c c . m o v   =   @ a p l i c a 
 a n d   c c . m o v i d   =   @ a p l i c a i d 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   p o l i t i c a s m o n e d e r o a p l i c a d a s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ o r i g e n i d 
 a n d   c v e e s t a t u s   =   ' p ' ) 
 b e g i n 
 e x e c   x p m o v e s t a t u s c x c   @ e m p r e s a , 
 @ s u c u r s a l , 
 @ m o d u l o , 
 @ o r i g e n i d , 
 @ e s t a t u s , 
 @ e s t a t u s , 
 @ u s u a r i o , 
 @ f e c h a e m i s i o n , 
 @ f e c h a r e g i s t r o , 
 @ m o v f , 
 @ m o v i d f , 
 ' v t a s . f ' , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t 
 e n d 
 e n d 
 e n d 
 e n d 
 i f   @ m o d u l o   =   ' c x c ' 
 a n d   @ a c c i o n   =   ' c a n c e l a r ' 
 a n d   @ e s t a t u s   =   ' c a n c e l a d o ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ e s t a t u s   =   e s t a t u s , 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 a p l i c a , 
 a p l i c a i d 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d ) 
 b e g i n 
 s e l e c t 
 @ a p l i c a   =   a p l i c a , 
 @ a p l i c a i d   =   a p l i c a i d 
 f r o m   c x c d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 j o i n   c o n d i c i o n   c o   w i t h   ( n o l o c k ) 
 o n   c x c . c o n d i c i o n   =   c o . c o n d i c i o n 
 w h e r e   m o v   =   @ a p l i c a 
 a n d   m o v i d   =   @ a p l i c a i d 
 a n d   d b o . f n c l a v e a f e c t a c i o n m a v i ( m o v ,   ' v t a s ' )   =   ' v t a s . f ' 
 a n d   e s t a t u s   < >   ' c o n c l u i d o ' 
 a n d   i s n u l l ( s a l d o ,   0 )   >   0 
 a n d   c o . t i p o c o n d i c i o n   =   ' c o n t a d o ' 
 a n d   c o . g r u p o   =   ' m e n u d e o ' ) 
 b e g i n 
 s e l e c t 
 @ o r i g e n i d   =   v . i d , 
 @ m o v f   =   c c . m o v , 
 @ m o v i d f   =   c c . m o v i d , 
 @ e m p r e s a   =   v . e m p r e s a , 
 @ s u c u r s a l   =   v . s u c u r s a l 
 f r o m   v e n t a   v   w i t h   ( n o l o c k ) 
 j o i n   c x c   c c   w i t h   ( n o l o c k ) 
 o n   v . m o v   =   c c . m o v 
 a n d   v . m o v i d   =   c c . m o v i d 
 w h e r e   c c . m o v   =   @ a p l i c a 
 a n d   c c . m o v i d   =   @ a p l i c a i d 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   p o l i t i c a s m o n e d e r o a p l i c a d a s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ o r i g e n i d 
 a n d   i s n u l l ( c v e e s t a t u s ,   ' ' )   =   ' a ' ) 
 b e g i n 
 e x e c   x p m o v e s t a t u s c x c   @ e m p r e s a , 
 @ s u c u r s a l , 
 @ m o d u l o , 
 @ o r i g e n i d , 
 @ e s t a t u s , 
 @ e s t a t u s , 
 @ u s u a r i o , 
 @ f e c h a e m i s i o n , 
 @ f e c h a r e g i s t r o , 
 @ m o v f , 
 @ m o v i d f , 
 ' v t a s . f ' , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t 
 e n d 
 e n d 
 e n d 
 e n d 
 e n d 
 i f   @ m o d u l o   =   ' c x p ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ e s t a t u s   =   e s t a t u s 
 f r o m   c x p   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' a c u e r d o   p r o v e e d o r ' 
 a n d   @ e s t a t u s   =   ' p e n d i e n t e ' 
 e x e c   s p _ d m 0 3 1 0 m o v f l u j o a c u e r d o p r o v e e d o r e s   @ i d 
 e n d 
 i f   @ m o d u l o   =   ' c x p ' 
 a n d   @ a c c i o n   =   ' c a n c e l a r ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ e s t a t u s   =   e s t a t u s , 
 @ o r i g e n   =   o r i g e n , 
 @ o r i g e n i d p e d   =   o r i g e n i d 
 f r o m   c x p   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o v   =   ' a c u e r d o   p r o v e e d o r ' 
 a n d   @ e s t a t u s   =   ' c a n c e l a d o ' 
 u p d a t e   c x p   w i t h   ( r o w l o c k ) 
 s e t   s i t u a c i o n   =   ' p o r   g e n e r a r   a c u e r d o ' 
 w h e r e   m o v   =   @ o r i g e n 
 a n d   m o v i d   =   @ o r i g e n i d p e d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o v   i n   ( ' f a c t u r a ' ,   ' f a c t u r a   v i u ' ) 
 b e g i n 
 s e l e c t 
 @ i d s o p o r t e   =   r e p o r t e s e r v i c i o 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ i d s o p o r t e   i s   n o t   n u l l 
 b e g i n 
 u p d a t e   s   w i t h   ( r o w l o c k ) 
 s e t   c o n t r o l r e p s e r v   =   1 
 f r o m   s o p o r t e   s 
 w h e r e   s . i d   =   @ i d s o p o r t e 
 e n d 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o v   i n   ( ' f a c t u r a ' ,   ' f a c t u r a   v i u ' ) 
 b e g i n 
 s e l e c t 
 @ i d s o p o r t e   =   r e p o r t e s e r v i c i o 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ i d s o p o r t e   i s   n o t   n u l l 
 b e g i n 
 u p d a t e   s   w i t h   ( r o w l o c k ) 
 s e t   c o n t r o l r e p s e r v   =   1 
 f r o m   s o p o r t e   s 
 w h e r e   s . i d   =   @ i d s o p o r t e 
 e n d 
 e n d 
 i f   ( @ m o v   =   ' f a c t u r a ' 
 o r   @ m o v   =   ' c r e d i l a n a ' 
 o r   @ m o v   =   ' d e v o l u c i o n   v e n t a ' ) 
 b e g i n 
 e x e c   s p i d m 0 2 6 4 _ c a l c m o n e d e r o d i m a   @ i d 
 e n d 
 i f   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 i f   ( s e l e c t 
 c o u n t ( * ) 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   i n   ( ' d e v   a n t i c i p o   c o n t a d o ' ,   ' d e v o l u c i o n   e n g a n c h e ' ) 
 a n d   e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   i d   =   @ i d ) 
 >   0 
 b e g i n 
 e x e c   s p v t a s c o n s u l t a r i d v e n t a p o r d e v o l u c i o n   @ i d 
 e n d 
 e n d 
 i f   @ m o d u l o   =   ' v t a s ' 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ e s t a t u s   =   e s t a t u s 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   ( @ m o v   =   ' f a c t u r a ' 
 o r   @ m o v   =   ' f a c t u r a   v i u ' ) 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 e x e c   s p c x c b o n i f x e n g a n c h e   @ i d , 
 @ u s u a r i o 
 e n d 
 i f   @ a c c i o n   =   ' a f e c t a r ' 
 a n d   @ m o v   i n   ( ' f a c t u r a ' ,   ' c r e d i l a n a ' ) 
 a n d   @ e s t a t u s   =   ' c o n c l u i d o ' 
 a n d   @ c a n a l v e n t a   =   7 6 
 b e g i n 
 s e l e c t 
 @ d i a s p c d n   =   n u m e r o 
 f r o m   t a b l a n u m d   w i t h   ( n o l o c k ) 
 w h e r e   t a b l a n u m   =   ' d i a s   p c d n ' 
 s e l e c t 
 @ f e c h a a s i g v a l e   =   m i n ( f e c h a _ a s i g n a c i o n ) 
 f r o m   d m 0 2 4 4 _ f o l i o s _ v a l e s   w i t h   ( n o l o c k ) 
 w h e r e   c u e n t a   =   @ c t e 
 i f   @ f e c h a e m i s i o n   < =   d a t e a d d ( d a y ,   @ d i a s p c d n ,   @ f e c h a a s i g v a l e ) 
 b e g i n 
 u p d a t e   v e n t a   w i t h   ( r o w l o c k ) 
 s e t   v t a d i m a n u e v o   =   1 
 w h e r e   i d   =   @ i d 
 e n d 
 e n d 
 r e t u r n 
 e n d 