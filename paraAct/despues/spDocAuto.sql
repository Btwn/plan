u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p d o c a u t o ]   @ i d   i n t , 
 @ i n t e r e s e s m o v   c h a r ( 2 0 ) , 
 @ d o c m o v   c h a r ( 2 0 ) , 
 @ u s u a r i o   c h a r ( 1 0 )   =   n u l l , 
 @ c o n e x i o n   b i t   =   0 , 
 @ s i n c r o f i n a l   b i t   =   0 , 
 @ o k   i n t   =   n u l l   o u t p u t , 
 @ o k r e f   v a r c h a r ( 2 5 5 )   =   n u l l   o u t p u t 
 a s 
 b e g i n 
 d e c l a r e   @ s u c u r s a l   i n t , 
 @ a   i n t , 
 @ e m p r e s a   c h a r ( 5 ) , 
 @ m o d u l o   c h a r ( 5 ) , 
 @ c u e n t a   c h a r ( 1 0 ) , 
 @ m o n e d a   c h a r ( 1 0 ) , 
 @ m o v   c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ m o v t i p o   c h a r ( 2 0 ) , 
 @ m o v a p l i c a i m p o r t e   m o n e y , 
 @ c o n d i c i o n   v a r c h a r ( 5 0 ) , 
 @ i m p o r t e   m o n e y , 
 @ i m p u e s t o s   m o n e y , 
 @ i m p o r t e d o c u m e n t a r   m o n e y , 
 @ i m p o r t e t o t a l   m o n e y , 
 @ i n t e r e s e s   m o n e y , 
 @ i n t e r e s e s i m p u e s t o s   m o n e y , 
 @ i n t e r e s e s c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ i n t e r e s e s a p l i c a i m p o r t e   m o n e y , 
 @ n u m e r o d o c u m e n t o s   i n t , 
 @ p r i m e r v e n c i m i e n t o   d a t e t i m e , 
 @ p e r i o d o   c h a r ( 1 5 ) , 
 @ c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ o b s e r v a c i o n e s   v a r c h a r ( 1 0 0 ) , 
 @ e s t a t u s   c h a r ( 1 5 ) , 
 @ d o c e s t a t u s   c h a r ( 1 5 ) , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ f e c h a r e g i s t r o   d a t e t i m e , 
 @ m o v u s u a r i o   c h a r ( 1 0 ) , 
 @ p r o y e c t o   v a r c h a r ( 5 0 ) , 
 @ r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ t i p o c a m b i o   f l o a t , 
 @ s a l d o   m o n e y , 
 @ i n t e r e s e s i d   i n t , 
 @ i n t e r e s e s m o v i d   v a r c h a r ( 2 0 ) , 
 @ d o c i d   i n t , 
 @ d o c m o v i d   v a r c h a r ( 2 0 ) , 
 @ d o c i m p o r t e   m o n e y , 
 @ s u m a i m p o r t e 1   m o n e y , 
 @ s u m a i m p o r t e 2   m o n e y , 
 @ s u m a i m p o r t e 3   m o n e y , 
 @ d o c a u t o f o l i o   c h a r ( 2 0 ) , 
 @ i m p o r t e 1   m o n e y , 
 @ i m p o r t e 2   m o n e y , 
 @ i m p o r t e 3   m o n e y , 
 @ d i f   m o n e y , 
 @ v e n c i m i e n t o   d a t e t i m e , 
 @ d i a   i n t , 
 @ e s q u i n c e   b i t , 
 @ i m p p r i m e r d o c   b i t , 
 @ m e n s a j e   v a r c h a r ( 2 5 5 ) , 
 @ p p f e c h a e m i s i o n   d a t e t i m e , 
 @ p p v e n c i m i e n t o   d a t e t i m e , 
 @ p p d i a s   i n t , 
 @ p p f e c h a p r o n t o p a   d a t e t i m e , 
 @ p p d e s c u e n t o p r o n t o p a   f l o a t , 
 @ c l i e n t e e n v i a r a   i n t , 
 @ c o b r a d o r   v a r c h a r ( 5 0 ) , 
 @ p e r s o n a l c o b r a d o r   c h a r ( 1 0 ) , 
 @ a g e n t e   c h a r ( 1 0 ) , 
 @ d e s g l o s a r i m p u e s t o s   b i t , 
 @ a p l i c a i m p u e s t o s   m o n e y , 
 @ r e d o n d e o m o n e t a r i o s   i n t , 
 @ t a s a   v a r c h a r ( 5 0 ) , 
 @ r a m a i d   i n t , 
 @ i n t e r e s p o r c e n t a j e   f l o a t , 
 @ p a m e n s u a l   m o n e y , 
 @ c a p i t a l a n t e r i o r   m o n e y , 
 @ c a p i t a l i n s o l u t o   m o n e y , 
 @ c f g d o c a u t o b o r r a d o r   b i t , 
 @ c o r t e d i a s   i n t , 
 @ m e n o s d i a s   i n t 
 s e t   @ c o r t e d i a s   =   2 
 s e l e c t 
 @ r e d o n d e o m o n e t a r i o s   =   r e d o n d e o m o n e t a r i o s 
 f r o m   v e r s i o n   w i t h   ( n o l o c k ) 
 s e l e c t 
 @ e s q u i n c e   =   0 , 
 @ s a l d o   =   0 . 0 , 
 @ p r o y e c t o   =   n u l l , 
 @ f e c h a r e g i s t r o   =   g e t d a t e ( ) , 
 @ s u m a i m p o r t e 1   =   0 . 0 , 
 @ s u m a i m p o r t e 2   =   0 . 0 , 
 @ s u m a i m p o r t e 3   =   0 . 0 , 
 @ d e s g l o s a r i m p u e s t o s   =   0 
 s e l e c t 
 @ s u c u r s a l   =   s u c u r s a l , 
 @ e m p r e s a   =   e m p r e s a , 
 @ m o d u l o   =   m o d u l o , 
 @ c u e n t a   =   c u e n t a , 
 @ m o n e d a   =   m o n e d a , 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ i m p o r t e d o c u m e n t a r   =   i m p o r t e d o c u m e n t a r , 
 @ i n t e r e s e s   =   i s n u l l ( i n t e r e s e s ,   0 . 0 ) , 
 @ i n t e r e s e s i m p u e s t o s   =   i s n u l l ( i n t e r e s e s i m p u e s t o s ,   0 . 0 ) , 
 @ i n t e r e s e s c o n c e p t o   =   i n t e r e s e s c o n c e p t o , 
 @ n u m e r o d o c u m e n t o s   =   n u m e r o d o c u m e n t o s , 
 @ p r i m e r v e n c i m i e n t o   =   p r i m e r v e n c i m i e n t o , 
 @ p e r i o d o   =   u p p e r ( p e r i o d o ) , 
 @ c o n c e p t o   =   c o n c e p t o , 
 @ o b s e r v a c i o n e s   =   o b s e r v a c i o n e s , 
 @ e s t a t u s   =   e s t a t u s , 
 @ f e c h a e m i s i o n   =   f e c h a e m i s i o n , 
 @ m o v u s u a r i o   =   u s u a r i o , 
 @ i m p p r i m e r d o c   =   i m p p r i m e r d o c , 
 @ c o n d i c i o n   =   c o n d i c i o n , 
 @ i n t e r e s p o r c e n t a j e   =   n u l l i f ( i n t e r e s   /   1 0 0 ,   0 ) 
 f r o m   d o c a u t o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ t i p o c a m b i o   =   t i p o c a m b i o 
 f r o m   m o n   w i t h   ( n o l o c k ) 
 w h e r e   m o n e d a   =   @ m o n e d a 
 i f   n u l l i f ( r t r i m ( @ u s u a r i o ) ,   ' ' )   i s   n u l l 
 s e l e c t 
 @ u s u a r i o   =   @ m o v u s u a r i o 
 s e l e c t 
 @ m o v t i p o   =   c l a v e 
 f r o m   m o v t i p o   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   @ m o d u l o 
 a n d   m o v   =   @ m o v 
 s e l e c t 
 @ p p f e c h a e m i s i o n   =   @ f e c h a e m i s i o n , 
 @ d o c m o v   =   n u l l i f ( n u l l i f ( r t r i m ( @ d o c m o v ) ,   ' ' ) ,   ' 0 ' ) 
 i f   @ d o c m o v   i s   n u l l 
 s e l e c t 
 @ o k   =   1 0 1 6 0 
 s e l e c t 
 @ c f g d o c a u t o b o r r a d o r   =   i s n u l l ( c a s e   @ m o d u l o 
 w h e n   ' c x c '   t h e n   c x c d o c a u t o b o r r a d o r 
 e l s e   c x p d o c a u t o b o r r a d o r 
 e n d ,   0 ) 
 f r o m   e m p r e s a c f g 2   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 i f   @ c f g d o c a u t o b o r r a d o r   =   1 
 s e l e c t 
 @ d o c e s t a t u s   =   ' b o r r a d o r ' 
 e l s e 
 s e l e c t 
 @ d o c e s t a t u s   =   ' s i n a f e c t a r ' 
 i f   @ m o v t i p o   i n   ( ' c x c . a ' ,   ' c x c . a r ' ,   ' c x c . d a ' ,   ' c x c . n c ' ,   ' c x c . d a c ' ,   ' c x p . a ' ,   ' c x p . d a ' ,   ' c x p . n c ' ,   ' c x p . d a c ' ) 
 b e g i n 
 s e l e c t 
 @ i n t e r e s e s   =   0 . 0 , 
 @ i n t e r e s e s i m p u e s t o s   =   0 . 0 
 s e l e c t 
 @ d o c a u t o f o l i o   = 
 c a s e   @ m o d u l o 
 w h e n   ' c x c '   t h e n   n u l l i f ( r t r i m ( c x c d o c a n t i c i p o a u t o f o l i o ) ,   ' ' ) 
 w h e n   ' c x p '   t h e n   n u l l i f ( r t r i m ( c x p d o c a n t i c i p o a u t o f o l i o ) ,   ' ' ) 
 e l s e   n u l l 
 e n d 
 f r o m   e m p r e s a c f g   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 e n d 
 e l s e 
 s e l e c t 
 @ d o c a u t o f o l i o   = 
 c a s e   @ m o d u l o 
 w h e n   ' c x c '   t h e n   n u l l i f ( r t r i m ( c x c d o c a u t o f o l i o ) ,   ' ' ) 
 w h e n   ' c x p '   t h e n   n u l l i f ( r t r i m ( c x p d o c a u t o f o l i o ) ,   ' ' ) 
 e l s e   n u l l 
 e n d 
 f r o m   e m p r e s a c f g   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 i f   @ m o d u l o   =   ' c x c ' 
 s e l e c t 
 @ d e s g l o s a r i m p u e s t o s   =   i s n u l l ( c x c c o b r o i m p u e s t o s ,   0 ) 
 f r o m   e m p r e s a c f g 2   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 i f   @ e s t a t u s   =   ' s i n a f e c t a r ' 
 a n d   @ n u m e r o d o c u m e n t o s   >   0 
 b e g i n 
 i f   @ m o d u l o   =   ' c x c ' 
 s e l e c t 
 @ r a m a i d   =   i d , 
 @ i m p o r t e   =   i s n u l l ( i m p o r t e ,   0 . 0 ) , 
 @ i m p u e s t o s   =   i s n u l l ( i m p u e s t o s ,   0 . 0 ) , 
 @ s a l d o   =   i s n u l l ( s a l d o ,   0 . 0 ) , 
 @ p r o y e c t o   =   p r o y e c t o , 
 @ c l i e n t e e n v i a r a   =   c l i e n t e e n v i a r a , 
 @ a g e n t e   =   a g e n t e , 
 @ c o b r a d o r   =   c o b r a d o r , 
 @ p e r s o n a l c o b r a d o r   =   p e r s o n a l c o b r a d o r 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   c l i e n t e   =   @ c u e n t a 
 a n d   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 a n d   e s t a t u s   =   ' p e n d i e n t e ' 
 e l s e 
 i f   @ m o d u l o   =   ' c x p ' 
 s e l e c t 
 @ r a m a i d   =   i d , 
 @ i m p o r t e   =   i s n u l l ( i m p o r t e ,   0 . 0 ) , 
 @ i m p u e s t o s   =   i s n u l l ( i m p u e s t o s ,   0 . 0 ) , 
 @ s a l d o   =   i s n u l l ( s a l d o ,   0 . 0 ) , 
 @ p r o y e c t o   =   p r o y e c t o 
 f r o m   c x p   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   p r o v e e d o r   =   @ c u e n t a 
 a n d   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 a n d   e s t a t u s   =   ' p e n d i e n t e ' 
 s e l e c t 
 @ i m p o r t e t o t a l   =   @ i m p o r t e d o c u m e n t a r   +   @ i n t e r e s e s   +   @ i n t e r e s e s i m p u e s t o s 
 i f   @ s a l d o   <   @ i m p o r t e d o c u m e n t a r 
 s e l e c t 
 @ o k   =   3 5 1 9 0 
 i f   @ o k   i s   n u l l 
 b e g i n 
 i f   @ c o n e x i o n   =   0 
 b e g i n   t r a n s a c t i o n 
 i f   @ i n t e r e s e s   >   0 . 0 
 b e g i n 
 s e l e c t 
 @ r e f e r e n c i a   =   r t r i m ( @ m o v )   +   '   '   +   l t r i m ( c o n v e r t ( c h a r ,   @ m o v i d ) ) 
 i f   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 i n s e r t   c x c   ( s u c u r s a l ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   m o v ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   e s t a t u s , 
 c l i e n t e ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o ,   i m p o r t e ,   i m p u e s t o s , 
 c l i e n t e e n v i a r a ,   a g e n t e ,   c o b r a d o r ,   p e r s o n a l c o b r a d o r ,   t a s a ,   r a m a i d ) 
 v a l u e s   ( @ s u c u r s a l ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   @ e m p r e s a ,   @ i n t e r e s e s m o v ,   @ f e c h a e m i s i o n ,   @ i n t e r e s e s c o n c e p t o ,   @ p r o y e c t o ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   @ r e f e r e n c i a ,   @ o b s e r v a c i o n e s ,   @ d o c e s t a t u s ,   @ c u e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ i n t e r e s e s ,   @ i n t e r e s e s i m p u e s t o s ,   @ c l i e n t e e n v i a r a ,   @ a g e n t e ,   @ c o b r a d o r ,   @ p e r s o n a l c o b r a d o r ,   @ t a s a ,   @ r a m a i d ) 
 s e l e c t 
 @ i n t e r e s e s i d   =   @ @ i d e n t i t y 
 e n d 
 e l s e 
 i f   @ m o d u l o   =   ' c x p ' 
 b e g i n 
 i n s e r t   c x p   ( s u c u r s a l ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   m o v ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   e s t a t u s , 
 p r o v e e d o r ,   p r o v e e d o r m o n e d a ,   p r o v e e d o r t i p o c a m b i o ,   i m p o r t e ,   i m p u e s t o s ,   t a s a ,   r a m a i d ) 
 v a l u e s   ( @ s u c u r s a l ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   @ e m p r e s a ,   @ i n t e r e s e s m o v ,   @ f e c h a e m i s i o n ,   @ i n t e r e s e s c o n c e p t o ,   @ p r o y e c t o ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   @ r e f e r e n c i a ,   @ o b s e r v a c i o n e s ,   @ d o c e s t a t u s ,   @ c u e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ i n t e r e s e s ,   @ i n t e r e s e s i m p u e s t o s ,   @ t a s a ,   @ r a m a i d ) 
 s e l e c t 
 @ i n t e r e s e s i d   =   @ @ i d e n t i t y 
 e n d 
 i f   @ c f g d o c a u t o b o r r a d o r   =   0 
 e x e c   s p c x   @ i n t e r e s e s i d , 
 @ m o d u l o , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 @ f e c h a r e g i s t r o , 
 n u l l , 
 @ u s u a r i o , 
 1 , 
 0 , 
 @ i n t e r e s e s m o v   o u t p u t , 
 @ i n t e r e s e s m o v i d   o u t p u t , 
 n u l l , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t 
 e n d 
 e l s e 
 s e l e c t 
 @ i n t e r e s e s i m p u e s t o s   =   0 . 0 
 i f   @ p e r i o d o   =   ' q u i n c e n a l ' 
 b e g i n 
 s e l e c t 
 @ d i a   =   d a t e p a r t ( d d ,   @ p r i m e r v e n c i m i e n t o ) 
 s e l e c t 
 @ m e n o s d i a s   =   d a t e p a r t ( d d ,   d a t e a d d ( m m ,   1 ,   @ p r i m e r v e n c i m i e n t o ) ) 
 s e l e c t 
 @ m e n o s d i a s   =   ( @ d i a   -   @ m e n o s d i a s )   +   1 5 
 i f   @ d i a   < =   1 5 
 b e g i n 
 s e l e c t 
 @ e s q u i n c e   =   1 , 
 @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   1 5   -   @ d i a ,   @ p r i m e r v e n c i m i e n t o ) 
 s e t   @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   @ c o r t e d i a s ,   @ p r i m e r v e n c i m i e n t o ) 
 u p d a t e   v e n t a   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 e n d 
 e l s e 
 b e g i n 
 i f   @ d i a   > =   1 6 
 a n d   @ d i a   < =   3 0 
 b e g i n 
 s e l e c t 
 @ e s q u i n c e   =   0 , 
 @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   - d a t e p a r t ( d d ,   @ p r i m e r v e n c i m i e n t o ) ,   d a t e a d d ( m m ,   1 ,   @ p r i m e r v e n c i m i e n t o ) ) 
 s e t   @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   @ c o r t e d i a s ,   @ p r i m e r v e n c i m i e n t o ) 
 i f   ( d a t e p a r t ( d d ,   @ p r i m e r v e n c i m i e n t o )   =   1 ) 
 s e t   @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   1 ,   @ p r i m e r v e n c i m i e n t o ) 
 i f   ( d a t e p a r t ( d d ,   @ p r i m e r v e n c i m i e n t o )   =   3 1 ) 
 s e t   @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   2 ,   @ p r i m e r v e n c i m i e n t o ) 
 u p d a t e   v e n t a   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 e n d 
 e l s e 
 b e g i n 
 s e l e c t 
 @ e s q u i n c e   =   0 , 
 @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   - d a t e p a r t ( d d ,   @ p r i m e r v e n c i m i e n t o ) ,   d a t e a d d ( m m ,   1 ,   @ p r i m e r v e n c i m i e n t o ) ) 
 s e t   @ p r i m e r v e n c i m i e n t o   =   d a t e a d d ( d d ,   @ c o r t e d i a s   +   @ m e n o s d i a s ,   @ p r i m e r v e n c i m i e n t o ) 
 u p d a t e   v e n t a   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 e n d 
 e n d 
 e n d 
 i f   @ i m p p r i m e r d o c   =   1 
 a n d   @ i m p o r t e d o c u m e n t a r   =   @ i m p o r t e   +   @ i m p u e s t o s 
 s e l e c t 
 @ i m p o r t e d o c u m e n t a r   =   @ i m p o r t e 
 s e l e c t 
 @ a   =   1 , 
 @ m o v a p l i c a i m p o r t e   =   r o u n d ( @ i m p o r t e d o c u m e n t a r   /   @ n u m e r o d o c u m e n t o s ,   @ r e d o n d e o m o n e t a r i o s ) , 
 @ i n t e r e s e s a p l i c a i m p o r t e   =   r o u n d ( ( @ i n t e r e s e s   +   @ i n t e r e s e s i m p u e s t o s )   /   @ n u m e r o d o c u m e n t o s ,   @ r e d o n d e o m o n e t a r i o s ) , 
 @ v e n c i m i e n t o   =   @ p r i m e r v e n c i m i e n t o 
 s e l e c t 
 @ p a m e n s u a l   =   @ m o v a p l i c a i m p o r t e   +   i s n u l l ( @ i n t e r e s e s a p l i c a i m p o r t e ,   0 ) 
 i f   @ i m p p r i m e r d o c   =   1 
 s e l e c t 
 @ d o c i m p o r t e   =   @ m o v a p l i c a i m p o r t e 
 e l s e 
 s e l e c t 
 @ d o c i m p o r t e   =   @ m o v a p l i c a i m p o r t e   +   @ i n t e r e s e s a p l i c a i m p o r t e 
 s e l e c t 
 @ c a p i t a l a n t e r i o r   =   @ i m p o r t e d o c u m e n t a r 
 w h i l e   ( @ a   < =   @ n u m e r o d o c u m e n t o s ) 
 a n d   @ o k   i s   n u l l 
 b e g i n 
 s e l e c t 
 @ i m p o r t e 1   =   0 . 0 , 
 @ i m p o r t e 2   =   0 . 0 , 
 @ i m p o r t e 3   =   0 . 0 
 i f   @ i m p p r i m e r d o c   =   1 
 a n d   @ a   =   1 
 b e g i n 
 s e l e c t 
 @ i m p o r t e 1   =   @ d o c i m p o r t e   +   @ i m p u e s t o s   +   @ i n t e r e s e s   +   @ i n t e r e s e s i m p u e s t o s , 
 @ i m p o r t e 2   =   @ d o c i m p o r t e   +   @ i m p u e s t o s , 
 @ i m p o r t e 3   =   @ i n t e r e s e s   +   @ i n t e r e s e s i m p u e s t o s 
 e n d 
 e l s e 
 b e g i n 
 s e l e c t 
 @ i m p o r t e 1   =   @ d o c i m p o r t e , 
 @ i m p o r t e 2   =   @ m o v a p l i c a i m p o r t e 
 i f   @ i m p p r i m e r d o c   =   1 
 s e l e c t 
 @ i m p o r t e 3   =   0 . 0 
 e l s e 
 b e g i n 
 s e l e c t 
 @ i m p o r t e 3   =   @ i n t e r e s e s a p l i c a i m p o r t e 
 i f   @ i n t e r e s p o r c e n t a j e   i s   n o t   n u l l 
 b e g i n 
 s e l e c t 
 @ c a p i t a l i n s o l u t o   =   ( @ i m p o r t e d o c u m e n t a r   *   p o w e r ( 1   +   @ i n t e r e s p o r c e n t a j e ,   @ a ) )   -   ( @ p a m e n s u a l   *   ( ( p o w e r ( 1   +   @ i n t e r e s p o r c e n t a j e ,   @ a )   -   1 )   /   @ i n t e r e s p o r c e n t a j e ) ) 
 s e l e c t 
 @ i m p o r t e 2   =   @ c a p i t a l a n t e r i o r   -   @ c a p i t a l i n s o l u t o 
 s e l e c t 
 @ i m p o r t e 3   =   @ m o v a p l i c a i m p o r t e   +   @ i n t e r e s e s a p l i c a i m p o r t e   -   @ i m p o r t e 2 
 s e l e c t 
 @ c a p i t a l a n t e r i o r   =   @ c a p i t a l i n s o l u t o 
 e n d 
 e n d 
 e n d 
 s e l e c t 
 @ s u m a i m p o r t e 1   =   @ s u m a i m p o r t e 1   +   @ i m p o r t e 1 , 
 @ s u m a i m p o r t e 2   =   @ s u m a i m p o r t e 2   +   @ i m p o r t e 2 , 
 @ s u m a i m p o r t e 3   =   @ s u m a i m p o r t e 3   +   @ i m p o r t e 3 
 i f   @ a   =   @ n u m e r o d o c u m e n t o s 
 b e g i n 
 s e l e c t 
 @ d i f   =   @ s u m a i m p o r t e 2   -   @ i m p o r t e d o c u m e n t a r 
 i f   @ d i f   < >   0 . 0 
 s e l e c t 
 @ i m p o r t e 1   =   @ i m p o r t e 1   -   @ d i f , 
 @ i m p o r t e 2   =   @ i m p o r t e 2   -   @ d i f 
 s e l e c t 
 @ d i f   =   @ s u m a i m p o r t e 3   -   ( @ i n t e r e s e s   +   @ i n t e r e s e s i m p u e s t o s ) 
 i f   @ d i f   < >   0 . 0 
 s e l e c t 
 @ i m p o r t e 1   =   @ i m p o r t e 1   -   @ d i f , 
 @ i m p o r t e 3   =   @ i m p o r t e 3   -   @ d i f 
 e n d 
 s e l e c t 
 @ r e f e r e n c i a   =   r t r i m ( @ m o v )   +   '   '   +   l t r i m ( r t r i m ( c o n v e r t ( c h a r ,   @ m o v i d ) ) )   +   '   ( '   +   l t r i m ( r t r i m ( c o n v e r t ( c h a r ,   @ a ) ) )   +   ' / '   +   l t r i m ( r t r i m ( c o n v e r t ( c h a r ,   @ n u m e r o d o c u m e n t o s ) ) )   +   ' ) ' 
 i f   @ m o v   =   @ d o c a u t o f o l i o 
 s e l e c t 
 @ d o c m o v i d   =   r t r i m ( @ m o v i d )   +   ' - '   +   l t r i m ( c o n v e r t ( c h a r ,   @ a ) ) 
 e l s e 
 s e l e c t 
 @ d o c m o v i d   =   n u l l 
 e x e c   s p c a l c u l a r v e n c i m i e n t o p p   @ m o d u l o , 
 @ e m p r e s a , 
 @ c u e n t a , 
 @ c o n d i c i o n , 
 @ p p f e c h a e m i s i o n , 
 @ p p v e n c i m i e n t o   o u t p u t , 
 @ p p d i a s   o u t p u t , 
 @ p p f e c h a p r o n t o p a   o u t p u t , 
 @ p p d e s c u e n t o p r o n t o p a   o u t p u t , 
 @ t a s a   o u t p u t , 
 @ o k   o u t p u t 
 i f   @ m o d u l o   =   ' c x c ' 
 b e g i n 
 i n s e r t   c x c   ( s u c u r s a l ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   e s t a t u s , 
 c l i e n t e ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o ,   i m p o r t e ,   c o n d i c i o n ,   v e n c i m i e n t o ,   a p l i c a m a n u a l ,   f e c h a p r o n t o p a ,   d e s c u e n t o p r o n t o p a , 
 c l i e n t e e n v i a r a ,   a g e n t e ,   c o b r a d o r ,   p e r s o n a l c o b r a d o r ,   t a s a ,   r a m a i d ) 
 v a l u e s   ( @ s u c u r s a l ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   @ e m p r e s a ,   @ d o c m o v ,   @ d o c m o v i d ,   @ f e c h a e m i s i o n ,   @ c o n c e p t o ,   @ p r o y e c t o ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   @ r e f e r e n c i a ,   @ o b s e r v a c i o n e s ,   @ d o c e s t a t u s ,   @ c u e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ i m p o r t e 1 ,   ' ( f e c h a ) ' ,   @ v e n c i m i e n t o ,   1 ,   @ p p f e c h a p r o n t o p a ,   @ p p d e s c u e n t o p r o n t o p a ,   @ c l i e n t e e n v i a r a ,   @ a g e n t e ,   @ c o b r a d o r ,   @ p e r s o n a l c o b r a d o r ,   @ t a s a ,   @ r a m a i d ) 
 s e l e c t 
 @ d o c i d   =   @ @ i d e n t i t y 
 i f   @ i m p o r t e 2   >   0 . 0 
 i n s e r t   c x c d   ( s u c u r s a l ,   i d ,   r e n g l o n ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ) 
 v a l u e s   ( @ s u c u r s a l ,   @ d o c i d ,   2 0 4 8 ,   @ m o v ,   @ m o v i d ,   @ i m p o r t e 2 ) 
 i f   @ i m p o r t e 3   >   0 . 0 
 i n s e r t   c x c d   ( s u c u r s a l ,   i d ,   r e n g l o n ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ) 
 v a l u e s   ( @ s u c u r s a l ,   @ d o c i d ,   4 0 9 6 ,   @ i n t e r e s e s m o v ,   @ i n t e r e s e s m o v i d ,   @ i m p o r t e 3 ) 
 i f   @ d e s g l o s a r i m p u e s t o s   =   1 
 b e g i n 
 s e l e c t 
 @ a p l i c a i m p u e s t o s   =   n u l l i f ( s u m ( d . i m p o r t e   *   c . i v a f i s c a l   *   i s n u l l ( c . i e p s f i s c a l ,   1 ) ) ,   0 ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) , 
 c x c   c   w i t h   ( n o l o c k ) 
 w h e r e   d . i d   =   @ d o c i d 
 a n d   c . e m p r e s a   =   @ e m p r e s a 
 a n d   c . m o v   =   d . a p l i c a 
 a n d   c . m o v i d   =   d . a p l i c a i d 
 a n d   c . e s t a t u s   =   ' p e n d i e n t e ' 
 a n d   f e c h a e m i s i o n   =   @ f e c h a e m i s i o n 
 i f   @ a p l i c a i m p u e s t o s   i s   n o t   n u l l 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   i m p o r t e   =   i m p o r t e   -   @ a p l i c a i m p u e s t o s , 
 i m p u e s t o s   =   @ a p l i c a i m p u e s t o s 
 w h e r e   i d   =   @ d o c i d 
 e n d 
 e n d 
 e l s e 
 i f   @ m o d u l o   =   ' c x p ' 
 b e g i n 
 i n s e r t   c x p   ( s u c u r s a l ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   e s t a t u s , 
 p r o v e e d o r ,   p r o v e e d o r m o n e d a ,   p r o v e e d o r t i p o c a m b i o ,   i m p o r t e ,   c o n d i c i o n ,   v e n c i m i e n t o ,   a p l i c a m a n u a l ,   f e c h a p r o n t o p a ,   d e s c u e n t o p r o n t o p a ,   t a s a ,   r a m a i d ) 
 v a l u e s   ( @ s u c u r s a l ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   @ e m p r e s a ,   @ d o c m o v ,   @ d o c m o v i d ,   @ f e c h a e m i s i o n ,   @ c o n c e p t o ,   @ p r o y e c t o ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   @ r e f e r e n c i a ,   @ o b s e r v a c i o n e s ,   @ d o c e s t a t u s ,   @ c u e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ i m p o r t e 1 ,   ' ( f e c h a ) ' ,   @ v e n c i m i e n t o ,   1 ,   @ p p f e c h a p r o n t o p a ,   @ p p d e s c u e n t o p r o n t o p a ,   @ t a s a ,   @ r a m a i d ) 
 s e l e c t 
 @ d o c i d   =   @ @ i d e n t i t y 
 i f   @ i m p o r t e 2   >   0 . 0 
 i n s e r t   c x p d   ( s u c u r s a l ,   i d ,   r e n g l o n ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ) 
 v a l u e s   ( @ s u c u r s a l ,   @ d o c i d ,   2 0 4 8 ,   @ m o v ,   @ m o v i d ,   @ i m p o r t e 2 ) 
 i f   @ i m p o r t e 3   >   0 . 0 
 i n s e r t   c x p d   ( s u c u r s a l ,   i d ,   r e n g l o n ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ) 
 v a l u e s   ( @ s u c u r s a l ,   @ d o c i d ,   4 0 9 6 ,   @ i n t e r e s e s m o v ,   @ i n t e r e s e s m o v i d ,   @ i m p o r t e 3 ) 
 e n d 
 i f   @ c f g d o c a u t o b o r r a d o r   =   0 
 e x e c   s p c x   @ d o c i d , 
 @ m o d u l o , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 @ f e c h a r e g i s t r o , 
 n u l l , 
 @ u s u a r i o , 
 1 , 
 0 , 
 @ d o c m o v   o u t p u t , 
 @ d o c m o v i d   o u t p u t , 
 n u l l , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t 
 i f   @ o k   i s   n u l l 
 b e g i n 
 s e l e c t 
 @ p p f e c h a e m i s i o n   =   d a t e a d d ( d a y ,   1 ,   @ v e n c i m i e n t o ) 
 i f   i s n u m e r i c ( @ p e r i o d o )   =   1 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( d a y ,   c o n v e r t ( i n t ,   @ p e r i o d o )   *   @ a ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' s e m a n a l ' 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( w k ,   @ a ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' m e n s u a l ' 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( m m ,   @ a ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' b i m e s t r a l ' 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( m m ,   @ a   *   2 ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' t r i m e s t r a l ' 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( m m ,   @ a   *   3 ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' s e m e s t r a l ' 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( m m ,   @ a   *   6 ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' a n u a l ' 
 s e l e c t 
 @ v e n c i m i e n t o   =   d a t e a d d ( y y ,   @ a ,   @ p r i m e r v e n c i m i e n t o ) 
 e l s e 
 i f   @ p e r i o d o   =   ' q u i n c e n a l ' 
 b e g i n 
 i f   @ e s q u i n c e   =   1 
 s e l e c t 
 @ e s q u i n c e   =   0 , 
 @ v e n c i m i e n t o   =   d a t e a d d ( d d ,   - 1 5 ,   d a t e a d d ( m m ,   1 ,   @ v e n c i m i e n t o ) ) 
 e l s e 
 s e l e c t 
 @ e s q u i n c e   =   1 , 
 @ v e n c i m i e n t o   =   d a t e a d d ( d d ,   1 5 ,   @ v e n c i m i e n t o ) 
 e n d 
 e l s e 
 s e l e c t 
 @ o k   =   5 5 1 4 0 
 s e l e c t 
 @ a   =   @ a   +   1 
 e n d 
 e n d 
 i f   @ c o n e x i o n   =   0 
 b e g i n 
 i f   @ o k   i s   n u l l 
 c o m m i t   t r a n s a c t i o n 
 e l s e 
 r o l l b a c k   t r a n s a c t i o n 
 e n d 
 e n d 
 e n d 
 e l s e 
 s e l e c t 
 @ o k   =   6 0 0 4 0 
 i f   @ o k   i s   n u l l 
 s e l e c t 
 @ m e n s a j e   =   " p r o c e s o   c o n c l u i d o . " 
 e l s e 
 b e g i n 
 s e l e c t 
 @ m e n s a j e   =   d e s c r i p c i o n 
 f r o m   m e n s a j e l i s t a   w i t h   ( n o l o c k ) 
 w h e r e   m e n s a j e   =   @ o k 
 i f   @ o k r e f   i s   n o t   n u l l 
 s e l e c t 
 @ m e n s a j e   =   r t r i m ( @ m e n s a j e )   +   ' < b r > < b r > '   +   @ o k r e f 
 e n d 
 i f   @ c o n e x i o n   =   0 
 s e l e c t 
 @ m e n s a j e 
 r e t u r n 
 e n d 