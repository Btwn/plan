u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p m o v c o p i a r e n c a b e z a d o ]   @ s u c u r s a l   i n t , 
 @ m o d u l o   c h a r ( 5 ) , 
 @ i d   i n t , 
 @ e m p r e s a   c h a r ( 5 ) , 
 @ m o v   c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ u s u a r i o   c h a r ( 1 0 ) , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ e s t a t u s   c h a r ( 1 5 ) , 
 @ m o n e d a   c h a r ( 1 0 ) , 
 @ t i p o c a m b i o   f l o a t , 
 @ a l m a c e n   c h a r ( 1 0 ) , 
 @ a l m a c e n d e s t i n o   c h a r ( 1 0 ) , 
 @ g e n e r a r d i r e c t o   b i t , 
 @ g e n e r a r m o v   c h a r ( 2 0 ) , 
 @ g e n e r a r m o v i d   v a r c h a r ( 2 0 ) , 
 @ g e n e r a r i d   i n t   o u t p u t , 
 @ o k   i n t   o u t p u t , 
 @ c o p i a r b i t a c o r a   b i t   =   0 , 
 @ c o p i a r s u c u r s a l d e s t i n o   b i t   =   0 
 a s 
 b e g i n 
 d e c l a r e   @ c o n t a c t o   c h a r ( 1 0 ) , 
 @ c o n d i c i o n   v a r c h a r ( 5 0 ) , 
 @ v e n c i m i e n t o   d a t e t i m e , 
 @ o r i g e n t i p o   c h a r ( 1 0 ) , 
 @ o r i g e n   c h a r ( 2 0 ) , 
 @ o r i g e n i d   v a r c h a r ( 2 0 ) , 
 @ u s a r s u c u r s a l m o v o r i g e n   b i t , 
 @ a c   b i t , 
 @ c f g t i p o c a m b i o   v a r c h a r ( 2 0 ) 
 e x e c   s p e x t r a e r f e c h a   @ f e c h a e m i s i o n   o u t p u t 
 s e l e c t 
 @ c f g t i p o c a m b i o   =   t i p o c a m b i o 
 f r o m   e m p r e s a c f g m o d u l o   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   @ m o d u l o 
 i f   @ c f g t i p o c a m b i o   =   ' v e n t a ' 
 s e l e c t 
 @ t i p o c a m b i o   =   t i p o c a m b i o v e n t a 
 f r o m   m o n   w i t h   ( n o l o c k ) 
 w h e r e   m o n e d a   =   @ m o n e d a 
 e l s e 
 i f   @ c f g t i p o c a m b i o   =   ' c o m p r a ' 
 s e l e c t 
 @ t i p o c a m b i o   =   t i p o c a m b i o c o m p r a 
 f r o m   m o n   w i t h   ( n o l o c k ) 
 w h e r e   m o n e d a   =   @ m o n e d a 
 s e l e c t 
 @ u s a r s u c u r s a l m o v o r i g e n   =   u s a r s u c u r s a l m o v o r i g e n , 
 @ a c   =   a c 
 f r o m   e m p r e s a g r a l   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 i f   @ u s a r s u c u r s a l m o v o r i g e n   =   0 
 s e l e c t 
 @ s u c u r s a l   =   s u c u r s a l 
 f r o m   u s u a r i o s u c u r s a l   w i t h   ( n o l o c k ) 
 w h e r e   u s u a r i o   =   @ u s u a r i o 
 i f   @ m o v   i s   n o t   n u l l 
 a n d   @ m o v i d   i s   n o t   n u l l 
 s e l e c t 
 @ o r i g e n t i p o   =   @ m o d u l o , 
 @ o r i g e n   =   @ m o v , 
 @ o r i g e n i d   =   @ m o v i d 
 i f   @ m o d u l o   =   ' c o n t ' 
 i n s e r t   c o n t   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   f e c h a c o n t a b l e ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   i n t e r c o m p a n i a ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a f e c t a r p r e s u p u e s t o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 i n t e r c o m p a n i a , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a f e c t a r p r e s u p u e s t o 
 f r o m   c o n t   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' v t a s ' 
 i n s e r t   v e n t a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   d i r e c t o ,   a l m a c e n ,   a l m a c e n d e s t i n o ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   p r i o r i d a d ,   c o d i ,   c l i e n t e ,   e n v i a r a ,   a g e n t e ,   a g e n t e s e r v i c i o ,   f o r m a e n v i o ,   f e c h a r e q u e r i d a ,   h o r a r e q u e r i d a ,   f e c h a o r i g i n a l ,   f e c h a o r d e n c o m p r a ,   r e f e r e n c i a o r d e n c o m p r a ,   o r d e n c o m p r a ,   c o n d i c i o n ,   v e n c i m i e n t o ,   c t a d i n e r o ,   d e s c u e n t o ,   d e s c u e n t o g l o b a l ,   s e r v i c i o t i p o ,   s e r v i c i o a r t i c u l o ,   s e r v i c i o s e r i e ,   s e r v i c i o c o n t r a t o ,   s e r v i c i o c o n t r a t o i d ,   s e r v i c i o c o n t r a t o t i p o ,   s e r v i c i o g a r a n t i a ,   s e r v i c i o d e s c r i p c i o n ,   s e r v i c i o f l o t i l l a ,   s e r v i c i o r a m p a ,   s e r v i c i o i d e n t i f i c a d o r ,   s e r v i c i o f e c h a ,   s e r v i c i o p l a c a s ,   s e r v i c i o k m s ,   s e r v i c i o s i n i e s t r o ,   a t e n c i o n ,   d e p a r t a m e n t o ,   z o n a i m p u e s t o ,   l i s t a p r e c i o s e s p ,   g e n e r a r o p ,   d e s g l o s a r i m p u e s t o s ,   d e s g l o s a r i m p u e s t o 2 ,   e x c l u i r p l a n e a c i o n ,   c o n v i g e n c i a ,   v i g e n c i a d e s d e ,   v i g e n c i a h a s t a ,   b o n i f i c a c i o n ,   c a u s a ,   p e r i o d i c i d a d ,   s u b m o d u l o ,   c o n t u s o ,   e s p a c i o ,   a u t o c o r r i d a ,   a u t o c o r r i d a h o r a ,   a u t o c o r r i d a s e r v i c i o ,   a u t o c o r r i d a r o l ,   a u t o c o r r i d a o r i g e n ,   a u t o c o r r i d a d e s t i n o ,   a u t o c o r r i d a k m s ,   a u t o c o r r i d a l t s ,   a u t o c o r r i d a r u t a ,   a u t o b o l e t o ,   a u t o k m s ,   a u t o k m s a c t u a l e s ,   a u t o b o m b a ,   a u t o b o m b a c o n t a d o r ,   g a s t o a c r e e d o r ,   g a s t o c o n c e p t o ,   c o m e n t a r i o s ,   s e r v i c i o t i p o o r d e n ,   s e r v i c i o t i p o o p e r a c i o n ,   s e r v i c i o e x p r e s s ,   s e r v i c i o d e m e r i t o ,   s e r v i c i o d e d u c i b l e ,   s e r v i c i o d e d u c i b l e i m p o r t e ,   s e r v i c i o n u m e r o ,   s e r v i c i o n u m e r o e c o n o m i c o ,   s e r v i c i o a s e g u r a d o r a ,   s u c u r s a l v e n t a ,   r e n g l o n i d ,   a f ,   a f a r t i c u l o ,   a f s e r i e ,   c o n t r a t o t i p o ,   c o n t r a t o d e s c r i p c i o n ,   c o n t r a t o s e r i e ,   c o n t r a t o v a l o r ,   c o n t r a t o v a l o r m o n e d a ,   c o n t r a t o s e g u r o ,   c o n t r a t o v e n c i m i e n t o ,   c o n t r a t o r e s p o n s a b l e ,   c l a s e ,   s u b c l a s e ,   e n d o s a r a ,   l i n e a c r e d i t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   t i e n e t a s a e s p ,   t a s a e s p ,   c o m i s i o n e s ,   c o m i s i o n e s i v a ,   a g e n t e c o m i s i o n ,   s e r v i c i o p o l i z a ,   f o r m a p a t i p o ,   s o b r e p r e c i o ,   a f e c t a c o m i s i o n m a v i ,   f o r m a c o b r o ,   n o c t a p a ,   c t e f i n a l ,   i d e c o m m e r c e ,   p a d i e ,   r e p o r t e d e s c u e n t o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 @ g e n e r a r d i r e c t o , 
 @ a l m a c e n , 
 @ a l m a c e n d e s t i n o , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 p r i o r i d a d , 
 c o d i , 
 c l i e n t e , 
 e n v i a r a , 
 a g e n t e , 
 a g e n t e s e r v i c i o , 
 f o r m a e n v i o , 
 f e c h a r e q u e r i d a , 
 h o r a r e q u e r i d a , 
 f e c h a o r i g i n a l , 
 f e c h a o r d e n c o m p r a , 
 r e f e r e n c i a o r d e n c o m p r a , 
 o r d e n c o m p r a , 
 c o n d i c i o n , 
 v e n c i m i e n t o , 
 c t a d i n e r o , 
 d e s c u e n t o , 
 d e s c u e n t o g l o b a l , 
 s e r v i c i o t i p o , 
 s e r v i c i o a r t i c u l o , 
 s e r v i c i o s e r i e , 
 s e r v i c i o c o n t r a t o , 
 s e r v i c i o c o n t r a t o i d , 
 s e r v i c i o c o n t r a t o t i p o , 
 s e r v i c i o g a r a n t i a , 
 s e r v i c i o d e s c r i p c i o n , 
 s e r v i c i o f l o t i l l a , 
 s e r v i c i o r a m p a , 
 s e r v i c i o i d e n t i f i c a d o r , 
 s e r v i c i o f e c h a , 
 s e r v i c i o p l a c a s , 
 s e r v i c i o k m s , 
 s e r v i c i o s i n i e s t r o , 
 a t e n c i o n , 
 d e p a r t a m e n t o , 
 z o n a i m p u e s t o , 
 l i s t a p r e c i o s e s p , 
 g e n e r a r o p , 
 d e s g l o s a r i m p u e s t o s , 
 d e s g l o s a r i m p u e s t o 2 , 
 e x c l u i r p l a n e a c i o n , 
 c o n v i g e n c i a , 
 v i g e n c i a d e s d e , 
 v i g e n c i a h a s t a , 
 b o n i f i c a c i o n , 
 c a u s a , 
 p e r i o d i c i d a d , 
 s u b m o d u l o , 
 c o n t u s o , 
 e s p a c i o , 
 a u t o c o r r i d a , 
 a u t o c o r r i d a h o r a , 
 a u t o c o r r i d a s e r v i c i o , 
 a u t o c o r r i d a r o l , 
 a u t o c o r r i d a o r i g e n , 
 a u t o c o r r i d a d e s t i n o , 
 a u t o c o r r i d a k m s , 
 a u t o c o r r i d a l t s , 
 a u t o c o r r i d a r u t a , 
 a u t o b o l e t o , 
 a u t o k m s , 
 a u t o k m s a c t u a l e s , 
 a u t o b o m b a , 
 a u t o b o m b a c o n t a d o r , 
 g a s t o a c r e e d o r , 
 g a s t o c o n c e p t o , 
 c o m e n t a r i o s , 
 s e r v i c i o t i p o o r d e n , 
 s e r v i c i o t i p o o p e r a c i o n , 
 s e r v i c i o e x p r e s s , 
 s e r v i c i o d e m e r i t o , 
 s e r v i c i o d e d u c i b l e , 
 s e r v i c i o d e d u c i b l e i m p o r t e , 
 s e r v i c i o n u m e r o , 
 s e r v i c i o n u m e r o e c o n o m i c o , 
 s e r v i c i o a s e g u r a d o r a , 
 s u c u r s a l v e n t a , 
 r e n g l o n i d , 
 a f , 
 a f a r t i c u l o , 
 a f s e r i e , 
 c o n t r a t o t i p o , 
 c o n t r a t o d e s c r i p c i o n , 
 c o n t r a t o s e r i e , 
 c o n t r a t o v a l o r , 
 c o n t r a t o v a l o r m o n e d a , 
 c o n t r a t o s e g u r o , 
 c o n t r a t o v e n c i m i e n t o , 
 c o n t r a t o r e s p o n s a b l e , 
 c l a s e , 
 s u b c l a s e , 
 e n d o s a r a , 
 l i n e a c r e d i t o , 
 t i p o a m o r t i z a c i o n , 
 t i p o t a s a , 
 t i e n e t a s a e s p , 
 t a s a e s p , 
 c o m i s i o n e s , 
 c o m i s i o n e s i v a , 
 a g e n t e c o m i s i o n , 
 s e r v i c i o p o l i z a , 
 f o r m a p a t i p o , 
 s o b r e p r e c i o , 
 a f e c t a c o m i s i o n m a v i , 
 f o r m a c o b r o , 
 n o c t a p a , 
 c t e f i n a l , 
 i d e c o m m e r c e , 
 p a d i e , 
 r e p o r t e d e s c u e n t o 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' p r o d ' 
 i n s e r t   p r o d   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   d i r e c t o ,   a l m a c e n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   p r i o r i d a d ,   a u t o r e s e r v a r ,   v e r d e s t i n o ,   f e c h a i n i c i o ,   f e c h a e n t r e g a ,   r e n g l o n i d ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 @ g e n e r a r d i r e c t o , 
 @ a l m a c e n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 p r i o r i d a d , 
 a u t o r e s e r v a r , 
 v e r d e s t i n o , 
 f e c h a i n i c i o , 
 f e c h a e n t r e g a , 
 r e n g l o n i d 
 f r o m   p r o d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' c o m s ' 
 i n s e r t   c o m p r a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   d i r e c t o ,   a l m a c e n ,   c o n c e p t o ,   p r o y e c t o ,   a c t i v i d a d ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   p r i o r i d a d ,   p r o v e e d o r ,   f o r m a e n v i o ,   f e c h a e n t r e g a ,   f e c h a r e q u e r i d a ,   c o n d i c i o n ,   v e n c i m i e n t o ,   i n s t r u c c i o n ,   a g e n t e ,   d e s c u e n t o ,   d e s c u e n t o g l o b a l ,   a t e n c i o n ,   z o n a i m p u e s t o ,   i d i o m a ,   l i s t a p r e c i o s e s p ,   r e n g l o n i d ,   f o r m a e n t r e g a ,   c a n c e l a r p e n d i e n t e ,   l i n e a c r e d i t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   t i e n e t a s a e s p ,   t a s a e s p ,   c o m i s i o n e s ,   c o m i s i o n e s i v a ,   a u t o c a r s ,   c l i e n t e ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 @ g e n e r a r d i r e c t o , 
 @ a l m a c e n , 
 c o n c e p t o , 
 p r o y e c t o , 
 a c t i v i d a d , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 p r i o r i d a d , 
 p r o v e e d o r , 
 f o r m a e n v i o , 
 f e c h a e n t r e g a , 
 f e c h a r e q u e r i d a , 
 c o n d i c i o n , 
 v e n c i m i e n t o , 
 i n s t r u c c i o n , 
 a g e n t e , 
 d e s c u e n t o , 
 d e s c u e n t o g l o b a l , 
 a t e n c i o n , 
 z o n a i m p u e s t o , 
 i d i o m a , 
 l i s t a p r e c i o s e s p , 
 r e n g l o n i d , 
 f o r m a e n t r e g a , 
 c a n c e l a r p e n d i e n t e , 
 l i n e a c r e d i t o , 
 t i p o a m o r t i z a c i o n , 
 t i p o t a s a , 
 t i e n e t a s a e s p , 
 t a s a e s p , 
 c o m i s i o n e s , 
 c o m i s i o n e s i v a , 
 a u t o c a r s , 
 c l i e n t e 
 f r o m   c o m p r a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' i n v ' 
 i n s e r t   i n v   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   d i r e c t o ,   a l m a c e n ,   a l m a c e n d e s t i n o ,   c o n c e p t o ,   p r o y e c t o ,   a c t i v i d a d ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a l m a c e n t r a n s i t o ,   l a r ,   c o n d i c i o n ,   v e n c i m i e n t o ,   f o r m a e n v i o ,   v e r l o t e ,   v e r d e s t i n o ,   r e n g l o n i d ,   a g e n t e ,   p e r s o n a l ,   c o n t u s o m a v i ,   i d o r d t r a s m a v i ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 @ g e n e r a r d i r e c t o , 
 @ a l m a c e n , 
 @ a l m a c e n d e s t i n o , 
 c o n c e p t o , 
 p r o y e c t o , 
 a c t i v i d a d , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a l m a c e n t r a n s i t o , 
 l a r , 
 c o n d i c i o n , 
 v e n c i m i e n t o , 
 f o r m a e n v i o , 
 v e r l o t e , 
 v e r d e s t i n o , 
 r e n g l o n i d , 
 a g e n t e , 
 p e r s o n a l , 
 c o n t u s o m a v i , 
 i d o r d t r a s m a v i 
 f r o m   i n v   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' d i n ' 
 i n s e r t   d i n e r o   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   d i r e c t o ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   b e n e f i c i a r i o n o m b r e ,   l e y e n d a c h e q u e ,   b e n e f i c i a r i o ,   c t a d i n e r o ,   c t a d i n e r o d e s t i n o ,   c o n d e s g l o s e ,   i m p o r t e ,   c o m i s i o n e s ,   i m p u e s t o s ,   f o r m a p a ,   f e c h a p r o g r a m a d a ,   c a j e r o ,   c o n t a c t o ,   c o n t a c t o t i p o ,   t i p o c a m b i o d e s t i n o ,   p r o v e e d o r a u t o e n d o s o ,   c a r b a n c a r i o ,   c a r b a n c a r i o i v a ,   p r i o r i d a d ,   c o m e n t a r i o s ,   n o t a ,   f e c h a o r i g e n ,   v e n c i m i e n t o ,   t a s a ,   t a s a d i a s ,   t a s a r e t e n c i o n ,   r e t e n c i o n ,   c o n t u s o ,   c l i e n t e ,   c l i e n t e e n v i a r a ,   p r o v e e d o r ,   i n t e r e s t i p o ,   t i t u l o ,   t i t u l o v a l o r ,   v a l o r o r i g e n ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   d . s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 @ g e n e r a r d i r e c t o , 
 d . c o n c e p t o , 
 d . p r o y e c t o , 
 d . u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   d . t i p o c a m b i o ) , 
 d . r e f e r e n c i a , 
 d . o b s e r v a c i o n e s , 
 d . b e n e f i c i a r i o n o m b r e , 
 d . l e y e n d a c h e q u e , 
 d . b e n e f i c i a r i o , 
 d . c t a d i n e r o , 
 d . c t a d i n e r o d e s t i n o , 
 d . c o n d e s g l o s e , 
 d . i m p o r t e , 
 d . c o m i s i o n e s , 
 d . i m p u e s t o s , 
 d . f o r m a p a , 
 d . f e c h a p r o g r a m a d a , 
 d . c a j e r o , 
 d . c o n t a c t o , 
 d . c o n t a c t o t i p o , 
 d . t i p o c a m b i o d e s t i n o , 
 d . p r o v e e d o r a u t o e n d o s o , 
 d . c a r b a n c a r i o , 
 d . c a r b a n c a r i o i v a , 
 d . p r i o r i d a d , 
 d . c o m e n t a r i o s , 
 d . n o t a , 
 d . f e c h a o r i g e n , 
 d . v e n c i m i e n t o , 
 d . t a s a , 
 d . t a s a d i a s , 
 d . t a s a r e t e n c i o n , 
 d . r e t e n c i o n , 
 d . c o n t u s o , 
 d . c l i e n t e , 
 d . c l i e n t e e n v i a r a , 
 d . p r o v e e d o r , 
 d . i n t e r e s t i p o , 
 d . t i t u l o , 
 t . v a l o r , 
 d . v a l o r o r i g e n 
 f r o m   d i n e r o   d   w i t h   ( n o l o c k ) 
 l e f t   o u t e r   j o i n   t i t u l o   t   w i t h   ( n o l o c k ) 
 o n   t . t i t u l o   =   d . t i t u l o 
 w h e r e   d . i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' c x c ' 
 i n s e r t   c x c   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c o d i ,   c l i e n t e ,   c l i e n t e e n v i a r a ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o ,   c t a d i n e r o ,   c o b r a d o r ,   p e r s o n a l c o b r a d o r ,   f o r m a c o b r o ,   i m p o r t e ,   i m p u e s t o s ,   a p l i c a m a n u a l ,   a g e n t e ,   m o v a p l i c a ,   m o v a p l i c a i d ,   c o n d e s g l o s e ,   f o r m a c o b r o 1 ,   f o r m a c o b r o 2 ,   f o r m a c o b r o 3 ,   f o r m a c o b r o 4 ,   f o r m a c o b r o 5 ,   i m p o r t e 1 ,   i m p o r t e 2 ,   i m p o r t e 3 ,   i m p o r t e 4 ,   i m p o r t e 5 ,   r e f e r e n c i a 1 ,   r e f e r e n c i a 2 ,   r e f e r e n c i a 3 ,   r e f e r e n c i a 4 ,   r e f e r e n c i a 5 ,   c a m b i o ,   d e l e f e c t i v o ,   c a j e r o ,   f e c h a o r i g i n a l ,   c o m e n t a r i o s ,   n o t a ,   v i n ,   c o n t u s o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 c a s e 
 w h e n   o r i g e n t i p o   =   ' c a m '   t h e n   c x c . t i p o c a m b i o 
 e l s e   i s n u l l ( @ t i p o c a m b i o ,   c x c . t i p o c a m b i o ) 
 e n d , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c o d i , 
 c l i e n t e , 
 c l i e n t e e n v i a r a , 
 c l i e n t e m o n e d a , 
 c a s e 
 w h e n   o r i g e n t i p o   =   ' c a m '   t h e n   c l i e n t e t i p o c a m b i o 
 e l s e   c a s e   @ c f g t i p o c a m b i o 
 w h e n   ' v e n t a '   t h e n   m s . t i p o c a m b i o v e n t a 
 w h e n   ' c o m p r a '   t h e n   m s . t i p o c a m b i o c o m p r a 
 e l s e   m s . t i p o c a m b i o 
 e n d 
 e n d , 
 c t a d i n e r o , 
 c o b r a d o r , 
 p e r s o n a l c o b r a d o r , 
 f o r m a c o b r o , 
 i m p o r t e , 
 i m p u e s t o s , 
 a p l i c a m a n u a l , 
 a g e n t e , 
 m o v a p l i c a , 
 m o v a p l i c a i d , 
 c o n d e s g l o s e , 
 f o r m a c o b r o 1 , 
 f o r m a c o b r o 2 , 
 f o r m a c o b r o 3 , 
 f o r m a c o b r o 4 , 
 f o r m a c o b r o 5 , 
 i m p o r t e 1 , 
 i m p o r t e 2 , 
 i m p o r t e 3 , 
 i m p o r t e 4 , 
 i m p o r t e 5 , 
 r e f e r e n c i a 1 , 
 r e f e r e n c i a 2 , 
 r e f e r e n c i a 3 , 
 r e f e r e n c i a 4 , 
 r e f e r e n c i a 5 , 
 c a m b i o , 
 d e l e f e c t i v o , 
 c a j e r o , 
 f e c h a o r i g i n a l , 
 c o m e n t a r i o s , 
 n o t a , 
 v i n , 
 c o n t u s o 
 f r o m   c x c   w i t h   ( n o l o c k ) , 
 m o n   m s   w i t h   ( n o l o c k ) 
 w h e r e   m s . m o n e d a   =   c l i e n t e m o n e d a 
 a n d   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' c x p ' 
 i n s e r t   c x p   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   p r o v e e d o r ,   p r o v e e d o r s u c u r s a l ,   p r o v e e d o r m o n e d a ,   p r o v e e d o r t i p o c a m b i o ,   c t a d i n e r o ,   f o r m a p a ,   i m p o r t e ,   i m p u e s t o s ,   a p l i c a m a n u a l ,   b e n e f i c i a r i o ,   m o v a p l i c a ,   m o v a p l i c a i d ,   c a j e r o ,   p r o v e e d o r a u t o e n d o s o ,   c o m e n t a r i o s ,   n o t a ,   v i n ,   c o n t u s o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 c a s e 
 w h e n   o r i g e n t i p o   =   ' c a m '   t h e n   c x p . t i p o c a m b i o 
 e l s e   i s n u l l ( @ t i p o c a m b i o ,   c x p . t i p o c a m b i o ) 
 e n d , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 p r o v e e d o r , 
 p r o v e e d o r s u c u r s a l , 
 p r o v e e d o r m o n e d a , 
 c a s e 
 w h e n   o r i g e n t i p o   =   ' c a m '   t h e n   p r o v e e d o r t i p o c a m b i o 
 e l s e   c a s e   @ c f g t i p o c a m b i o 
 w h e n   ' v e n t a '   t h e n   m s . t i p o c a m b i o v e n t a 
 w h e n   ' c o m p r a '   t h e n   m s . t i p o c a m b i o c o m p r a 
 e l s e   m s . t i p o c a m b i o 
 e n d 
 e n d , 
 c t a d i n e r o , 
 f o r m a p a , 
 i m p o r t e , 
 i m p u e s t o s , 
 a p l i c a m a n u a l , 
 b e n e f i c i a r i o , 
 m o v a p l i c a , 
 m o v a p l i c a i d , 
 c a j e r o , 
 p r o v e e d o r a u t o e n d o s o , 
 c o m e n t a r i o s , 
 n o t a , 
 v i n , 
 c o n t u s o 
 f r o m   c x p   w i t h   ( n o l o c k ) , 
 m o n   m s   w i t h   ( n o l o c k ) 
 w h e r e   m s . m o n e d a   =   p r o v e e d o r m o n e d a 
 a n d   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' a g e n t ' 
 i n s e r t   a g e n t   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a g e n t e ,   c t a d i n e r o ,   f o r m a p a ,   i m p o r t e ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a g e n t e , 
 c t a d i n e r o , 
 f o r m a p a , 
 i m p o r t e 
 f r o m   a g e n t   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' g a s ' 
 i n s e r t   g a s t o   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   o b s e r v a c i o n e s ,   a c r e e d o r ,   c l a s e ,   s u b c l a s e ,   c t a d i n e r o ,   f o r m a p a ,   c o n d i c i o n ,   i m p o r t e ,   i m p u e s t o s ,   m o v a p l i c a ,   m o v a p l i c a i d ,   p e r i o d i c i d a d ,   t i e n e r e t e n c i o n ,   c x p ,   f e c h a r e q u e r i d a ,   a c t i v i d a d ,   a f ,   a f a r t i c u l o ,   a f s e r i e ,   c o n v i g e n c i a ,   v i g e n c i a d e s d e ,   v i g e n c i a h a s t a ,   c o n t r a t o t i p o ,   c o n t r a t o d e s c r i p c i o n ,   c o n t r a t o s e r i e ,   c o n t r a t o v a l o r ,   c o n t r a t o v a l o r m o n e d a ,   c o n t r a t o s e g u r o ,   c o n t r a t o v e n c i m i e n t o ,   c o n t r a t o r e s p o n s a b l e ,   p r i o r i d a d ,   a n e x o m o d u l o ,   a n e x o i d ,   c o m e n t a r i o s ,   n o t a ,   c l i e n t e r e f ,   a r t i c u l o r e f ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 o b s e r v a c i o n e s , 
 a c r e e d o r , 
 c l a s e , 
 s u b c l a s e , 
 c t a d i n e r o , 
 f o r m a p a , 
 c o n d i c i o n , 
 i m p o r t e , 
 i m p u e s t o s , 
 m o v a p l i c a , 
 m o v a p l i c a i d , 
 p e r i o d i c i d a d , 
 t i e n e r e t e n c i o n , 
 c x p , 
 f e c h a r e q u e r i d a , 
 a c t i v i d a d , 
 a f , 
 a f a r t i c u l o , 
 a f s e r i e , 
 c o n v i g e n c i a , 
 v i g e n c i a d e s d e , 
 v i g e n c i a h a s t a , 
 c o n t r a t o t i p o , 
 c o n t r a t o d e s c r i p c i o n , 
 c o n t r a t o s e r i e , 
 c o n t r a t o v a l o r , 
 c o n t r a t o v a l o r m o n e d a , 
 c o n t r a t o s e g u r o , 
 c o n t r a t o v e n c i m i e n t o , 
 c o n t r a t o r e s p o n s a b l e , 
 p r i o r i d a d , 
 a n e x o m o d u l o , 
 a n e x o i d , 
 c o m e n t a r i o s , 
 n o t a , 
 c l i e n t e r e f , 
 a r t i c u l o r e f 
 f r o m   g a s t o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' e m b ' 
 i n s e r t   e m b a r q u e   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   v e h i c u l o ,   r u t a ,   a g e n t e ,   f e c h a s a l i d a ,   f e c h a r e t o r n o ,   c t a d i n e r o ,   p r o v e e d o r ,   i m p o r t e ,   i m p u e s t o s ,   c o n d i c i o n ,   v e n c i m i e n t o ,   p e r s o n a l c o b r a d o r ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 v e h i c u l o , 
 r u t a , 
 a g e n t e , 
 f e c h a s a l i d a , 
 f e c h a r e t o r n o , 
 c t a d i n e r o , 
 p r o v e e d o r , 
 i m p o r t e , 
 i m p u e s t o s , 
 c o n d i c i o n , 
 v e n c i m i e n t o , 
 p e r s o n a l c o b r a d o r 
 f r o m   e m b a r q u e   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' n o m ' 
 i n s e r t   n o m i n a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   o b s e r v a c i o n e s ,   c o n d i c i o n ,   p e r i o d o t i p o ,   f e c h a d ,   f e c h a a ,   f e c h a o r i g e n ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 o b s e r v a c i o n e s , 
 c o n d i c i o n , 
 p e r i o d o t i p o , 
 f e c h a d , 
 f e c h a a , 
 f e c h a o r i g e n 
 f r o m   n o m i n a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' r h ' 
 i n s e r t   r h   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   e v a l u a c i o n ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 e v a l u a c i o n 
 f r o m   r h   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' a s i s ' 
 i n s e r t   a s i s t e   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   l o c a l i d a d ,   f e c h a d ,   f e c h a a ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 l o c a l i d a d , 
 f e c h a d , 
 f e c h a a 
 f r o m   a s i s t e   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' a f ' 
 i n s e r t   a c t i v o f i j o   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   p r o v e e d o r ,   c o n d i c i o n ,   v e n c i m i e n t o ,   i m p o r t e ,   i m p u e s t o s ,   f o r m a p a ,   c t a d i n e r o ,   t o d o ,   r e v a l u a r ,   v a l o r m e r c a d o ,   p e r s o n a l ,   e s p a c i o ,   c o n t u s o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 p r o v e e d o r , 
 c o n d i c i o n , 
 v e n c i m i e n t o , 
 i m p o r t e , 
 i m p u e s t o s , 
 f o r m a p a , 
 c t a d i n e r o , 
 t o d o , 
 r e v a l u a r , 
 v a l o r m e r c a d o , 
 p e r s o n a l , 
 e s p a c i o , 
 c o n t u s o 
 f r o m   a c t i v o f i j o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' p c ' 
 i n s e r t   p c   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   l i s t a m o d i f i c a r ,   r e c a l c u l a r ,   p a r c i a l ,   p r o v e e d o r ,   m e t o d o ,   m o n t o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 l i s t a m o d i f i c a r , 
 r e c a l c u l a r , 
 p a r c i a l , 
 p r o v e e d o r , 
 m e t o d o , 
 m o n t o 
 f r o m   p c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' o f e r ' 
 i n s e r t   o f e r t a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   f e c h a d ,   f e c h a a ,   h o r a d ,   h o r a a ,   d i a s e s p ,   t i p o ,   f o r m a ,   u s a r ,   t i e n e v o l u m e n ,   m o n t o m i n i m o ,   t o d a s s u c u r s a l e s ,   c a t e r i a ,   g r u p o ,   f a m i l i a ,   l i n e a ,   f a b r i c a n t e ,   p o r c e n t a j e ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 f e c h a d , 
 f e c h a a , 
 h o r a d , 
 h o r a a , 
 d i a s e s p , 
 t i p o , 
 f o r m a , 
 u s a r , 
 t i e n e v o l u m e n , 
 m o n t o m i n i m o , 
 t o d a s s u c u r s a l e s , 
 c a t e r i a , 
 g r u p o , 
 f a m i l i a , 
 l i n e a , 
 f a b r i c a n t e , 
 p o r c e n t a j e 
 f r o m   o f e r t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' v a l e ' 
 i n s e r t   v a l e   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c l i e n t e ,   a g e n t e ,   c o n d i c i o n ,   v e n c i m i e n t o ,   t i p o ,   p r e c i o ,   c a n t i d a d ,   i m p o r t e ,   f e c h a i n i c i o ,   d e s c u e n t o ,   d e s c u e n t o g l o b a l ,   c t a d i n e r o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c l i e n t e , 
 a g e n t e , 
 c o n d i c i o n , 
 v e n c i m i e n t o , 
 t i p o , 
 p r e c i o , 
 c a n t i d a d , 
 i m p o r t e , 
 g e t d a t e ( ) , 
 d e s c u e n t o , 
 d e s c u e n t o g l o b a l , 
 c t a d i n e r o 
 f r o m   v a l e   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' c r ' 
 i n s e r t   c r   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c a j a ,   c a j e r o ,   f e c h a d ,   f e c h a a ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c a j a , 
 c a j e r o , 
 f e c h a d , 
 f e c h a a 
 f r o m   c r   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' s t ' 
 i n s e r t   s o p o r t e   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c l i e n t e ,   e n v i a r a ,   a g e n t e ,   c o n t a c t o ,   t e l e f o n o ,   e x t e n c i o n ,   f a x ,   e m a i l ,   u s u a r i o r e s p o n s a b l e ,   t i e n e c o n t r a t o ,   p r i o r i d a d ,   c l a s e ,   s u b c l a s e ,   t i t u l o ,   p r o b l e m a ,   s o l u c i o n ,   c o m e n t a r i o s ,   p r o v e e d o r ,   p e r s o n a l ,   v e n c i m i e n t o ,   r e f e r e n c i a i n i c i a l ,   c o n d i c i o n p a ,   i m p o r t e ,   e s t a d o ,   c o n d i c i o n e n t r e g a ,   f e c h a i n i c i o ,   f e c h a t e r m i n o ,   v e r s i o n ,   t i e m p o ,   t i e m p o u n i d a d ,   s u b m o d u l o ,   e s p a c i o ,   v i n ,   s e r v i c i o t i p o ,   f e c h a r e q u e r i d a ,   d i r e c c i o n ,   d i r e c c i o n n u m e r o ,   e n t r e c a l l e s ,   p l a n o ,   d e l e g a c i o n ,   c o l o n i a ,   p o b l a c i o n ,   p a i s e s t a d o ,   p a i s ,   z o n a ,   c o d i p o s t a l ,   r e p o r t e ,   a r t i c u l o ,   c a u s a ,   c l a s e 1 ,   c l a s e 2 ,   c l a s e 3 ,   c l a s e 4 ,   c l a s e 5 ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c l i e n t e , 
 e n v i a r a , 
 a g e n t e , 
 c o n t a c t o , 
 t e l e f o n o , 
 e x t e n c i o n , 
 f a x , 
 e m a i l , 
 u s u a r i o r e s p o n s a b l e , 
 t i e n e c o n t r a t o , 
 p r i o r i d a d , 
 c l a s e , 
 s u b c l a s e , 
 t i t u l o , 
 p r o b l e m a , 
 s o l u c i o n , 
 c o m e n t a r i o s , 
 p r o v e e d o r , 
 p e r s o n a l , 
 @ f e c h a e m i s i o n , 
 r e f e r e n c i a i n i c i a l , 
 c o n d i c i o n p a , 
 i m p o r t e , 
 ' n o   c o m e n z a d o ' , 
 c o n d i c i o n e n t r e g a , 
 f e c h a i n i c i o , 
 f e c h a t e r m i n o , 
 v e r s i o n , 
 t i e m p o , 
 t i e m p o u n i d a d , 
 s u b m o d u l o , 
 e s p a c i o , 
 v i n , 
 s e r v i c i o t i p o , 
 f e c h a r e q u e r i d a , 
 d i r e c c i o n , 
 d i r e c c i o n n u m e r o , 
 e n t r e c a l l e s , 
 p l a n o , 
 d e l e g a c i o n , 
 c o l o n i a , 
 p o b l a c i o n , 
 p a i s e s t a d o , 
 p a i s , 
 z o n a , 
 c o d i p o s t a l , 
 r e p o r t e , 
 a r t i c u l o , 
 c a u s a , 
 c l a s e 1 , 
 c l a s e 2 , 
 c l a s e 3 , 
 c l a s e 4 , 
 c l a s e 5 
 f r o m   s o p o r t e   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 e l s e 
 i f   @ m o d u l o   =   ' c a p ' 
 i n s e r t   c a p i t a l   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a g e n t e ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a g e n t e 
 f r o m   c a p i t a l   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' i n c ' 
 i n s e r t   i n c i d e n c i a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   f e c h a a p l i c a c i o n ,   p e r s o n a l ,   n o m i n a c o n c e p t o ,   f e c h a d ,   f e c h a a ,   c a n t i d a d ,   v a l o r ,   p o r c e n t a j e ,   a c r e e d o r ,   v e n c i m i e n t o ,   r e p e t i r ,   p r o r r a t e a r ,   f r e c u e n c i a ,   v e c e s ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 f e c h a a p l i c a c i o n , 
 p e r s o n a l , 
 n o m i n a c o n c e p t o , 
 f e c h a d , 
 f e c h a a , 
 c a n t i d a d , 
 v a l o r , 
 p o r c e n t a j e , 
 a c r e e d o r , 
 v e n c i m i e n t o , 
 r e p e t i r , 
 p r o r r a t e a r , 
 f r e c u e n c i a , 
 v e c e s 
 f r o m   i n c i d e n c i a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' c o n c ' 
 i n s e r t   c o n c i l i a c i o n   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c t a d i n e r o ,   f e c h a d ,   f e c h a a ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c t a d i n e r o , 
 f e c h a d , 
 f e c h a a 
 f r o m   c o n c i l i a c i o n   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' p p t o ' 
 i n s e r t   p r e s u p   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s 
 f r o m   p r e s u p   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' c r e d i ' 
 i n s e r t   c r e d i t o   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   v e n c i m i e n t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   c o m i s i o n e s ,   c o m i s i o n e s i v a ,   d e u d o r ,   a c r e e d o r ,   i m p o r t e ,   c t a d i n e r o ,   f o r m a p a ,   l i n e a c r e d i t o e s p ,   l i n e a c r e d i t o ,   l i n e a c r e d i t o f o n d e o ,   t i e n e t a s a e s p ,   t a s a e s p ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 v e n c i m i e n t o , 
 t i p o a m o r t i z a c i o n , 
 t i p o t a s a , 
 c o m i s i o n e s , 
 c o m i s i o n e s i v a , 
 d e u d o r , 
 a c r e e d o r , 
 i m p o r t e , 
 c t a d i n e r o , 
 f o r m a p a , 
 l i n e a c r e d i t o e s p , 
 l i n e a c r e d i t o , 
 l i n e a c r e d i t o f o n d e o , 
 t i e n e t a s a e s p , 
 t a s a e s p 
 f r o m   c r e d i t o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' w m s ' 
 i n s e r t   w m s   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a l m a c e n ,   a g e n t e ,   c o n t e n e d o r ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a l m a c e n , 
 a g e n t e , 
 c o n t e n e d o r 
 f r o m   w m s   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' r s s ' 
 i n s e r t   r s s   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c a n a l ,   t i t u l o ,   h i p e r v i n c u l o ,   d e s c r i p c i o n ,   c o m e n t a r i o s ,   a u t o r ,   c a t e r i a ,   a r t o r i g e n ,   a d j u n t o ,   a d j u n t o u r l ,   a d j u n t o t a m a n o ,   a d j u n t o t i p o ,   f e c h a p u b l i c a c i o n ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c a n a l , 
 t i t u l o , 
 h i p e r v i n c u l o , 
 d e s c r i p c i o n , 
 c o m e n t a r i o s , 
 a u t o r , 
 c a t e r i a , 
 a r t o r i g e n , 
 a d j u n t o , 
 a d j u n t o u r l , 
 a d j u n t o t a m a n o , 
 a d j u n t o t i p o , 
 g e t d a t e ( ) 
 f r o m   r s s   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' c m p ' 
 i n s e r t   c a m p a n a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a s u n t o ,   a g e n t e ,   c a m p a n a t i p o ,   t i e n e v i g e n c i a ,   f e c h a d ,   f e c h a a ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a s u n t o , 
 a g e n t e , 
 c a m p a n a t i p o , 
 t i e n e v i g e n c i a , 
 f e c h a d , 
 f e c h a a 
 f r o m   c a m p a n a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' f i s ' 
 i n s e r t   f i s c a l   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   m o n e d a ,   t i p o c a m b i o ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   a c r e e d o r ,   c o n d i c i o n ,   v e n c i m i e n t o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 a c r e e d o r , 
 c o n d i c i o n , 
 v e n c i m i e n t o 
 f r o m   f i s c a l   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' f r m ' 
 i n s e r t   f o r m a e x t r a   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   f o r m a t i p o ,   a p l i c a ,   a p l i c a c l a v e ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 f o r m a t i p o , 
 a p l i c a , 
 a p l i c a c l a v e 
 f r o m   f o r m a e x t r a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' p r o y ' 
 i n s e r t   p r o y e c t o   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   m o n e d a ,   t i p o c a m b i o ,   c o n t a c t o t i p o ,   p r o s p e c t o ,   c l i e n t e ,   p r o v e e d o r ,   p e r s o n a l ,   a g e n t e ,   r i e s ,   p r o y e c t o r a m a ,   s u p e r v i s o r ,   c o m i e n z o ,   f i n ,   d i a s h a b i l e s ,   h o r a s d i a ,   m o n t o e s t i m a d o ,   p r o y e c t o r e e s t r u c t u r a r ,   r e e s t r u c t u r a r ,   c o m e n t a r i o s ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 @ m o n e d a , 
 i s n u l l ( @ t i p o c a m b i o ,   t i p o c a m b i o ) , 
 c o n t a c t o t i p o , 
 p r o s p e c t o , 
 c l i e n t e , 
 p r o v e e d o r , 
 p e r s o n a l , 
 a g e n t e , 
 r i e s , 
 p r o y e c t o r a m a , 
 s u p e r v i s o r , 
 c o m i e n z o , 
 f i n , 
 d i a s h a b i l e s , 
 h o r a s d i a , 
 m o n t o e s t i m a d o , 
 p r o y e c t o r e e s t r u c t u r a r , 
 0 , 
 c o m e n t a r i o s 
 f r o m   p r o y e c t o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   @ m o d u l o   =   ' c a m ' 
 i n s e r t   c a m b i o   ( u l t i m o c a m b i o ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   s u c u r s a l d e s t i n o ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d ,   e m p r e s a ,   u s u a r i o ,   e s t a t u s ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   c o n c e p t o ,   p r o y e c t o ,   u e n ,   r e f e r e n c i a ,   o b s e r v a c i o n e s ,   c l i e n t e ,   a g e n t e ,   c o n d i c i o n ,   v e n c i m i e n t o ) 
 s e l e c t 
 g e t d a t e ( ) , 
 @ s u c u r s a l , 
 @ s u c u r s a l , 
 c a s e 
 w h e n   @ c o p i a r s u c u r s a l d e s t i n o   =   1   t h e n   s u c u r s a l d e s t i n o 
 e l s e   @ s u c u r s a l 
 e n d , 
 @ o r i g e n t i p o , 
 @ o r i g e n , 
 @ o r i g e n i d , 
 @ e m p r e s a , 
 @ u s u a r i o , 
 @ e s t a t u s , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ f e c h a e m i s i o n , 
 c o n c e p t o , 
 p r o y e c t o , 
 u e n , 
 r e f e r e n c i a , 
 o b s e r v a c i o n e s , 
 c l i e n t e , 
 a g e n t e , 
 c o n d i c i o n , 
 v e n c i m i e n t o 
 f r o m   c a m b i o   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ g e n e r a r i d   =   @ @ i d e n t i t y 
 i f   @ a c   =   1 
 e x e c   s p c o p i a r t a b l a a m o r t i z a c i o n g u i a   @ m o d u l o , 
 @ i d , 
 @ m o d u l o , 
 @ g e n e r a r i d 
 e x e c   s p m o v c o p i a r f o r m a a n e x o   @ m o d u l o , 
 @ i d , 
 @ m o d u l o , 
 @ g e n e r a r i d 
 e x e c   s p m o v c o p i a r a n e x o s   @ s u c u r s a l , 
 @ m o d u l o , 
 @ i d , 
 @ m o d u l o , 
 @ g e n e r a r i d , 
 @ c o p i a r b i t a c o r a 
 e x e c   x p m o v c o p i a r e n c a b e z a d o   @ s u c u r s a l , 
 @ m o d u l o , 
 @ i d , 
 @ e m p r e s a , 
 @ m o v , 
 @ m o v i d , 
 @ u s u a r i o , 
 @ f e c h a e m i s i o n , 
 @ e s t a t u s , 
 @ m o n e d a , 
 @ t i p o c a m b i o , 
 @ a l m a c e n , 
 @ a l m a c e n d e s t i n o , 
 @ g e n e r a r d i r e c t o , 
 @ g e n e r a r m o v , 
 @ g e n e r a r m o v i d , 
 @ g e n e r a r i d , 
 @ o k   o u t p u t , 
 @ c o p i a r b i t a c o r a 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   e m p r e s a c f g m o d u l o   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   @ m o d u l o 
 a n d   u p p e r ( t i e m p o s )   =   ' s i ' ) 
 i n s e r t   m o v t i e m p o   ( m o d u l o ,   s u c u r s a l ,   i d ,   u s u a r i o ,   f e c h a i n i c i o ,   f e c h a c o m e n z o ,   e s t a t u s ) 
 v a l u e s   ( @ m o d u l o ,   @ s u c u r s a l ,   @ g e n e r a r i d ,   @ u s u a r i o ,   g e t d a t e ( ) ,   g e t d a t e ( ) ,   @ e s t a t u s ) 
 e n d 