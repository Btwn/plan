u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p e m b a r q u e a f e c t a r ] 
 @ i d   i n t , 
 @ a c c i o n   c h a r ( 2 0 ) , 
 @ e m p r e s a   c h a r ( 5 ) , 
 @ m o d u l o   c h a r ( 5 ) , 
 @ m o v   c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 )   o u t p u t , 
 @ m o v t i p o   c h a r ( 2 0 ) , 
 @ f e c h a e m i s i o n   d a t e t i m e , 
 @ f e c h a a f e c t a c i o n   d a t e t i m e , 
 @ f e c h a c o n c l u s i o n   d a t e t i m e , 
 @ p r o y e c t o   v a r c h a r ( 5 0 ) , 
 @ u s u a r i o   c h a r ( 1 0 ) , 
 @ a u t o r i z a c i o n   c h a r ( 1 0 ) , 
 @ d o c f u e n t e   i n t , 
 @ o b s e r v a c i o n e s   v a r c h a r ( 2 5 5 ) , 
 @ r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ e s t a t u s   c h a r ( 1 5 ) , 
 @ e s t a t u s n u e v o   c h a r ( 1 5 ) , 
 @ f e c h a r e g i s t r o   d a t e t i m e , 
 @ e j e r c i c i o   i n t , 
 @ p e r i o d o   i n t , 
 @ f e c h a s a l i d a   d a t e t i m e , 
 @ f e c h a r e t o r n o   d a t e t i m e , 
 @ v e h i c u l o   c h a r ( 1 0 ) , 
 @ p e r s o n a l c o b r a d o r   v a r c h a r ( 1 0 ) , 
 @ c o n e x i o n   b i t , 
 @ s i n c r o f i n a l   b i t , 
 @ s u c u r s a l   i n t , 
 @ s u c u r s a l d e s t i n o   i n t , 
 @ s u c u r s a l o r i g e n   i n t , 
 @ a n t e c e d e n t e i d   i n t , 
 @ a n t e c e d e n t e m o v t i p o   c h a r ( 2 0 ) , 
 @ c t a d i n e r o   c h a r ( 1 0 ) , 
 @ c f g a f e c t a r c o b r o s   b i t , 
 @ c f g m o d i f i c a r v e n c i m i e n t o   b i t , 
 @ c f g e s t a d o t r a n s i t o   v a r c h a r ( 5 0 ) , 
 @ c f g e s t a d o p e n d i e n t e   v a r c h a r ( 5 0 ) , 
 @ c f g g a s t o t a r i f a   b i t , 
 @ c f g a f e c t a r g a s t o t a r i f a   b i t , 
 @ c f g b a s e p r o r r a t e o   v a r c h a r ( 2 0 ) , 
 @ c f g d e s e m b a r q u e s p a r c i a l e s   b i t , 
 @ c f g c o n t x   b i t , 
 @ c f g c o n t x g e n e r a r   c h a r ( 2 0 ) , 
 @ g e n e r a r p o l i z a   b i t , 
 @ g e n e r a r m o v   c h a r ( 2 0 ) , 
 @ i d g e n e r a r   i n t   o u t p u t , 
 @ g e n e r a r m o v i d   v a r c h a r ( 2 0 )   o u t p u t , 
 @ o k   i n t   o u t p u t , 
 @ o k r e f   v a r c h a r ( 2 5 5 )   o u t p u t 
 a s   b e g i n 
 d e c l a r e 
 @ g e n e r a r   b i t , 
 @ g e n e r a r a f e c t a d o   b i t , 
 @ g e n e r a r m o d u l o   c h a r ( 5 ) , 
 @ g e n e r a r m o v t i p o   c h a r ( 2 0 ) , 
 @ g e n e r a r e s t a t u s   c h a r ( 1 5 ) , 
 @ g e n e r a r p e r i o d o   i n t , 
 @ g e n e r a r e j e r c i c i o   i n t , 
 @ e m b a r q u e m o v   i n t , 
 @ e m b a r q u e m o v i d   i n t , 
 @ e s t a d o   c h a r ( 3 0 ) , 
 @ e s t a d o t i p o   c h a r ( 2 0 ) , 
 @ f e c h a h o r a   d a t e t i m e , 
 @ i m p o r t e   m o n e y , 
 @ f o r m a   v a r c h a r ( 5 0 ) , 
 @ d e t a l l e r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ d e t a l l e o b s e r v a c i o n e s   v a r c h a r ( 1 0 0 ) , 
 @ m o v m o d u l o   c h a r ( 5 ) , 
 @ m o v m o d u l o i d   i n t , 
 @ m o v m o v   c h a r ( 2 0 ) , 
 @ m o v m o v i d   v a r c h a r ( 2 0 ) , 
 @ m o v m o v t i p o   c h a r ( 2 0 ) , 
 @ m o v e s t a t u s   c h a r ( 1 5 ) , 
 @ m o v m o n e d a   c h a r ( 1 0 ) , 
 @ m o v c o n d i c i o n   v a r c h a r ( 5 0 ) , 
 @ m o v v e n c i m i e n t o   d a t e t i m e , 
 @ m o v i m p o r t e   m o n e y , 
 @ m o v i m p u e s t o s   m o n e y , 
 @ m o v t i p o c a m b i o   f l o a t , 
 @ m o v p o r c e n t a j e   f l o a t , 
 @ p e s o   f l o a t , 
 @ a p l i c a i m p o r t e   m o n e y , 
 @ v o l u m e n   f l o a t , 
 @ p a q u e t e s   i n t , 
 @ c l i e n t e   c h a r ( 1 0 ) , 
 @ p r o v e e d o r   c h a r ( 1 0 ) , 
 @ c l i e n t e p r o v e e d o r   c h a r ( 1 0 ) , 
 @ c l i e n t e e n v i a r a   i n t , 
 @ a g e n t e   c h a r ( 1 0 ) , 
 @ s u m a p e s o   f l o a t , 
 @ s u m a v o l u m e n   f l o a t , 
 @ s u m a p a q u e t e s   i n t , 
 @ s u m a i m p o r t e p e s o s   m o n e y , 
 @ s u m a i m p u e s t o s p e s o s   m o n e y , 
 @ s u m a i m p o r t e e m b a r q u e   m o n e y , 
 @ f e c h a c a n c e l a c i o n   d a t e t i m e , 
 @ a n t e c e d e n t e e s t a t u s   c h a r ( 1 5 ) , 
 @ g e n e r a r a c c i o n   c h a r ( 2 0 ) , 
 @ d i a s   i n t , 
 @ c x m o d u l o   c h a r ( 5 ) , 
 @ c x m o v   c h a r ( 2 0 ) , 
 @ c x m o v i d   v a r c h a r ( 2 0 ) , 
 @ c t e m o d i f i c a r v e n c i m i e n t o   v a r c h a r ( 2 0 ) , 
 @ e n v i a r a m o d i f i c a r v e n c i m i e n t o   v a r c h a r ( 2 0 ) , 
 @ m o d i f i c a r v e n c i m i e n t o   b i t , 
 @ g a s t o a n e x o t o t a l p e s o s   m o n e y , 
 @ d i a r e t o r n o   d a t e t i m e , 
 @ t i e n e p e n d i e n t e s   b i t 
 s e l e c t   @ g e n e r a r   =   0 , 
 @ g e n e r a r a f e c t a d o   =   0 , 
 @ i d g e n e r a r   =   n u l l , 
 @ g e n e r a r m o d u l o   =   n u l l , 
 @ g e n e r a r m o v i d   =   n u l l , 
 @ g e n e r a r m o v t i p o   =   n u l l , 
 @ g e n e r a r e s t a t u s   =   ' s i n a f e c t a r ' , 
 @ t i e n e p e n d i e n t e s   =   0 
 i f   @ c f g d e s e m b a r q u e s p a r c i a l e s   =   1   a n d   @ m o v t i p o   i n   ( ' e m b . e ' ,   ' e m b . o c ' )   a n d   @ e s t a t u s n u e v o   =   ' c o n c l u i d o ' 
 b e g i n 
 i f   e x i s t s ( s e l e c t   d . i d   f r o m   e m b a r q u e d   d   j o i n   e m b a r q u e m o v   m   o n   d . e m b a r q u e m o v = m . i d   j o i n   e m b a r q u e e s t a d o   e   o n   d . e s t a d o = e . e s t a d o   w h e r e   d . i d   =   @ i d   a n d   u p p e r ( e . t i p o ) = ' p e n d i e n t e '   a n d   d . d e s e m b a r q u e p a r c i a l   =   0 ) 
 s e l e c t   @ t i e n e p e n d i e n t e s   =   1 ,   @ e s t a t u s n u e v o   =   ' p e n d i e n t e ' 
 e n d 
 e x e c   s p m o v c o n s e c u t i v o   @ s u c u r s a l ,   @ s u c u r s a l o r i g e n ,   @ s u c u r s a l d e s t i n o ,   @ e m p r e s a ,   @ u s u a r i o ,   @ m o d u l o ,   @ e j e r c i c i o ,   @ p e r i o d o ,   @ i d ,   @ m o v ,   n u l l ,   @ e s t a t u s ,   @ c o n c e p t o ,   @ a c c i o n ,   @ c o n e x i o n ,   @ s i n c r o f i n a l ,   @ m o v i d   o u t p u t ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 i f   @ e s t a t u s   i n   ( ' s i n a f e c t a r ' ,   ' b o r r a d o r ' ,   ' c o n f i r m a r ' )   a n d   @ a c c i o n   < >   ' c a n c e l a r '   a n d   @ o k   i s   n u l l 
 b e g i n 
 e x e c   s p m o v c h e c a r c o n s e c u t i v o   @ e m p r e s a ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   n u l l ,   @ e j e r c i c i o ,   @ p e r i o d o ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e n d 
 i f   @ a c c i o n   i n   ( ' c o n s e c u t i v o ' ,   ' s i n c r o ' )   a n d   @ o k   i s   n u l l 
 b e g i n 
 i f   @ a c c i o n   =   ' s i n c r o '   e x e c   s p a s i g n a r s u c u r s a l e s t a t u s   @ i d ,   @ m o d u l o ,   @ s u c u r s a l d e s t i n o ,   @ a c c i o n 
 s e l e c t   @ o k   =   8 0 0 6 0 ,   @ o k r e f   =   @ m o v i d 
 r e t u r n 
 e n d 
 i f   @ a c c i o n   =   ' g e n e r a r '   a n d   @ o k   i s   n u l l 
 b e g i n 
 e x e c   s p m o v g e n e r a r   @ s u c u r s a l ,   @ e m p r e s a ,   @ m o d u l o ,   @ e j e r c i c i o ,   @ p e r i o d o ,   @ u s u a r i o ,   @ f e c h a r e g i s t r o ,   @ g e n e r a r e s t a t u s , 
 n u l l ,   n u l l , 
 @ m o v ,   @ m o v i d ,   0 , 
 @ g e n e r a r m o v ,   n u l l ,   @ g e n e r a r m o v i d   o u t p u t ,   @ i d g e n e r a r   o u t p u t ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e x e c   s p m o v t i p o   @ m o d u l o ,   @ g e n e r a r m o v ,   @ f e c h a a f e c t a c i o n ,   @ e m p r e s a ,   n u l l ,   n u l l ,   @ g e n e r a r m o v t i p o   o u t p u t ,   @ g e n e r a r p e r i o d o   o u t p u t ,   @ g e n e r a r e j e r c i c i o   o u t p u t ,   @ o k   o u t p u t 
 i f   @ @ e r r o r   < >   0   s e l e c t   @ o k   =   1 
 i f   @ o k   i s   n u l l   s e l e c t   @ o k   =   8 0 0 3 0 
 r e t u r n 
 e n d 
 i f   @ o k   i s   n o t   n u l l   r e t u r n 
 i f   @ c o n e x i o n   =   0 
 b e g i n   t r a n s a c t i o n 
 e x e c   s p m o v e s t a t u s   @ m o d u l o ,   ' a f e c t a n d o ' ,   @ i d ,   @ g e n e r a r ,   @ i d g e n e r a r ,   @ g e n e r a r a f e c t a d o ,   @ o k   o u t p u t 
 i f   @ a c c i o n   =   ' a f e c t a r '   a n d   @ e s t a t u s   i n   ( ' s i n a f e c t a r ' ,   ' b o r r a d o r ' ,   ' c o n f i r m a r ' ) 
 i f   ( s e l e c t   s i n c r o   f r o m   v e r s i o n   )   =   1 
 e x e c   s p _ e x e c u t e s q l   n ' u p d a t e   e m b a r q u e d   s e t   s u c u r s a l   =   @ s u c u r s a l ,   s i n c r o c   =   1   w h e r e   i d   =   @ i d   a n d   ( s u c u r s a l   < >   @ s u c u r s a l   o r   s i n c r o c   < >   1 ) ' ,   n ' @ s u c u r s a l   i n t ,   @ i d   i n t ' ,   @ s u c u r s a l ,   @ i d 
 i f   @ a c c i o n   < >   ' c a n c e l a r ' 
 e x e c   s p r e g i s t r a r m o v i m i e n t o   @ s u c u r s a l ,   @ e m p r e s a ,   @ m o d u l o ,   @ m o v ,   @ m o v i d ,   @ i d ,   @ e j e r c i c i o ,   @ p e r i o d o ,   @ f e c h a r e g i s t r o ,   @ f e c h a e m i s i o n , 
 n u l l ,   @ p r o y e c t o ,   n u l l ,   n u l l , 
 @ u s u a r i o ,   @ a u t o r i z a c i o n ,   n u l l ,   @ d o c f u e n t e ,   @ o b s e r v a c i o n e s , 
 @ g e n e r a r ,   @ g e n e r a r m o v ,   @ g e n e r a r m o v i d ,   @ i d g e n e r a r , 
 @ o k   o u t p u t 
 s e l e c t   @ s u m a p e s o   =   0 . 0 , 
 @ s u m a v o l u m e n   =   0 . 0 , 
 @ s u m a p a q u e t e s   =   0 . 0 , 
 @ s u m a i m p o r t e p e s o s   =   0 . 0 , 
 @ s u m a i m p u e s t o s p e s o s   =   0 . 0 , 
 @ s u m a i m p o r t e e m b a r q u e =   0 . 0 
 d e c l a r e   c r e m b a r q u e   c u r s o r   f o r 
 s e l e c t   n u l l i f ( d . e m b a r q u e m o v ,   0 ) ,   d . e s t a d o ,   d . f e c h a h o r a ,   n u l l i f ( r t r i m ( d . f o r m a ) ,   ' ' ) ,   i s n u l l ( d . i m p o r t e ,   0 . 0 ) ,   n u l l i f ( r t r i m ( d . r e f e r e n c i a ) ,   ' ' ) ,   n u l l i f ( r t r i m ( d . o b s e r v a c i o n e s ) ,   ' ' ) , 
 m . i d ,   m . m o d u l o ,   m . m o d u l o i d ,   m . m o v ,   m . m o v i d ,   m . i m p o r t e ,   m . i m p u e s t o s ,   m . m o n e d a ,   m . t i p o c a m b i o ,   i s n u l l ( m . p e s o ,   0 . 0 ) ,   i s n u l l ( m . v o l u m e n ,   0 . 0 ) ,   i s n u l l ( d . p a q u e t e s ,   0 ) , 
 n u l l i f ( r t r i m ( m . c l i e n t e ) ,   ' ' ) ,   n u l l i f ( r t r i m ( m . p r o v e e d o r ) ,   ' ' ) ,   m . c l i e n t e e n v i a r a ,   u p p e r ( e . t i p o ) ,   i s n u l l ( d . m o v p o r c e n t a j e ,   0 ) 
 f r o m   e m b a r q u e d   d 
 j o i n   e m b a r q u e m o v   m   o n   d . e m b a r q u e m o v   =   m . i d 
 l e f t   o u t e r   j o i n   e m b a r q u e e s t a d o   e   o n   d . e s t a d o   =   e . e s t a d o 
 w h e r e   d . i d   =   @ i d   a n d   d . d e s e m b a r q u e p a r c i a l   =   0 
 o p e n   c r e m b a r q u e 
 f e t c h   n e x t   f r o m   c r e m b a r q u e   i n t o   @ e m b a r q u e m o v ,   @ e s t a d o ,   @ f e c h a h o r a ,   @ f o r m a ,   @ i m p o r t e ,   @ d e t a l l e r e f e r e n c i a ,   @ d e t a l l e o b s e r v a c i o n e s ,   @ e m b a r q u e m o v i d ,   @ m o v m o d u l o ,   @ m o v m o d u l o i d ,   @ m o v m o v ,   @ m o v m o v i d ,   @ m o v i m p o r t e ,   @ m o v i m p u e s t o s ,   @ m o v m o n e d a ,   @ m o v t i p o c a m b i o ,   @ p e s o ,   @ v o l u m e n ,   @ p a q u e t e s ,   @ c l i e n t e ,   @ p r o v e e d o r ,   @ c l i e n t e e n v i a r a ,   @ e s t a d o t i p o ,   @ m o v p o r c e n t a j e 
 i f   @ @ e r r o r   < >   0   s e l e c t   @ o k   =   1 
 i f   @ @ f e t c h _ s t a t u s   =   - 1   s e l e c t   @ o k   =   6 0 0 1 0 
 w h i l e   @ @ f e t c h _ s t a t u s   < >   - 1   a n d   @ o k   i s   n u l l 
 b e g i n 
 i f   @ a c c i o n   =   ' a f e c t a r '   a n d   @ m o v t i p o   =   ' e m b . o c '   a n d   @ m o v m o d u l o   =   ' c x c '   a n d   @ e s t a d o t i p o   =   ' c o b r a d o ' 
 i f   @ i m p o r t e   <   i s n u l l ( ( s e l e c t   s a l d o   f r o m   c x c   w h e r e   i d   =   @ m o v m o d u l o i d ) ,   0 ) 
 s e l e c t   @ e s t a d o t i p o   =   ' c o b r o   p a r c i a l ' 
 i f   @ @ f e t c h _ s t a t u s   < >   - 2   a n d   @ e m b a r q u e m o v   i s   n o t   n u l l   a n d   @ o k   i s   n u l l 
 b e g i n 
 i f   @ m o v t i p o   i n   ( ' e m b . e ' ,   ' e m b . o c ' ) 
 b e g i n 
 i f   @ a c c i o n   =   ' a f e c t a r '   a n d   @ e s t a t u s   =   ' s i n a f e c t a r ' 
 b e g i n 
 i f   @ m o v t i p o   =   ' e m b . o c '   a n d   @ m o v m o d u l o   =   ' c x c ' 
 u p d a t e   c x c   s e t   p e r s o n a l c o b r a d o r   =   @ p e r s o n a l c o b r a d o r   w h e r e   i d   =   @ m o v m o d u l o i d   a n d   i s n u l l ( p e r s o n a l c o b r a d o r ,   ' ' )   < >   @ p e r s o n a l c o b r a d o r 
 u p d a t e   e m b a r q u e d   s e t   e s t a d o   =   @ c f g e s t a d o t r a n s i t o   w h e r e   c u r r e n t   o f   c r e m b a r q u e 
 u p d a t e   e m b a r q u e m o v   s e t   m o v p o r c e n t a j e   =   i s n u l l ( m o v p o r c e n t a j e ,   0 )   +   @ m o v p o r c e n t a j e   w h e r e   i d   =   @ e m b a r q u e m o v i d 
 e n d 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 b e g i n 
 u p d a t e   e m b a r q u e d   s e t   e s t a d o   =   @ c f g e s t a d o p e n d i e n t e   w h e r e   c u r r e n t   o f   c r e m b a r q u e 
 u p d a t e   e m b a r q u e m o v   s e t   m o v p o r c e n t a j e   =   i s n u l l ( m o v p o r c e n t a j e ,   0 )   -   @ m o v p o r c e n t a j e   w h e r e   i d   =   @ e m b a r q u e m o v i d 
 e n d 
 i f   @ m o v m o d u l o   =   ' v t a s '   a n d   @ m o v t i p o   =   ' e m b . e '   a n d   ( ( @ a c c i o n   =   ' a f e c t a r '   a n d   @ e s t a t u s   =   ' s i n a f e c t a r ' )   o r   ( @ a c c i o n   =   ' c a n c e l a r '   a n d   ( @ e s t a t u s   =   ' p e n d i e n t e '   o r   @ e s t a d o t i p o   < >   ' d e s e m b a r c a r ' ) )   o r   ( @ e s t a d o t i p o   =   ' d e s e m b a r c a r '   a n d   @ a c c i o n   =   ' a f e c t a r ' ) ) 
 b e g i n 
 u p d a t e   v e n t a d   s e t   c a n t i d a d e m b a r c a d a   =   c a s e   w h e n   @ a c c i o n   =   ' c a n c e l a r '   o r   @ e s t a d o t i p o   =   ' d e s e m b a r c a r '   t h e n   i s n u l l ( d . c a n t i d a d e m b a r c a d a ,   0 )   -   i s n u l l ( e . c a n t i d a d ,   0 )   e l s e   i s n u l l ( d . c a n t i d a d e m b a r c a d a ,   0 )   +   i s n u l l ( e . c a n t i d a d   ,   0 )   e n d 
 f r o m   e m b a r q u e d a r t   e   ,   v e n t a d   d 
 w h e r e   e . i d   =   @ i d   a n d   e . e m b a r q u e m o v   =   @ e m b a r q u e m o v   a n d   e . m o d u l o   =   ' v t a s '   a n d   e . m o d u l o i d   =   d . i d   a n d   e . r e n g l o n   =   d . r e n g l o n   a n d   e . r e n g l o n s u b   =   d . r e n g l o n s u b 
 i f   e x i s t s ( s e l e c t   e . i d   f r o m   e m b a r q u e d a r t   e   j o i n   v e n t a d   d   o n   e . m o d u l o i d   =   d . i d   w h e r e   e . i d   =   @ i d   a n d   e . e m b a r q u e m o v   =   @ e m b a r q u e m o v   a n d   e . m o d u l o   =   ' v t a s '   a n d   d . c a n t i d a d e m b a r c a d a   < >   d . c a n t i d a d - i s n u l l ( d . c a n t i d a d c a n c e l a d a ,   0 ) ) 
 u p d a t e   e m b a r q u e m o v   s e t   a s i g n a d o i d   =   n u l l   w h e r e   i d   =   @ e m b a r q u e m o v 
 e n d 
 i f   ( @ a c c i o n   =   ' a f e c t a r '   a n d   @ e s t a t u s   =   ' p e n d i e n t e ' )   o r   ( @ a c c i o n   =   ' c a n c e l a r '   a n d   @ e s t a t u s   =   ' c o n c l u i d o ' ) 
 b e g i n 
 s e l e c t   @ g e n e r a r a c c i o n   =   @ a c c i o n 
 s e l e c t   @ m o v m o v t i p o   =   n u l l ,   @ m o v e s t a t u s   =   n u l l ,   @ a g e n t e   =   n u l l 
 s e l e c t   @ m o v m o v t i p o   =   c l a v e   f r o m   m o v t i p o   w h e r e   m o d u l o   =   @ m o v m o d u l o   a n d   m o v   =   @ m o v m o v 
 i f   @ m o v m o d u l o   =   ' v t a s ' 
 b e g i n 
 s e l e c t   @ m o v e s t a t u s   =   e s t a t u s ,   @ a g e n t e   =   a g e n t e ,   @ m o v c o n d i c i o n   =   c o n d i c i o n ,   @ m o v v e n c i m i e n t o   =   v e n c i m i e n t o   f r o m   v e n t a   w h e r e   i d   =   @ m o v m o d u l o i d 
 i f   @ e s t a d o t i p o   i n   ( ' e n t r e g a d o ' ,   ' c o b r a d o ' )   a n d   @ f e c h a h o r a   i s   n o t   n u l l   a n d   @ a c c i o n   < >   ' c a n c e l a r '   a n d   @ o k   i s   n u l l 
 b e g i n 
 s e l e c t   @ m o d i f i c a r v e n c i m i e n t o   =   @ c f g m o d i f i c a r v e n c i m i e n t o 
 s e l e c t   @ c t e m o d i f i c a r v e n c i m i e n t o   =   i s n u l l ( u p p e r ( m o d i f i c a r v e n c i m i e n t o ) ,   ' ( e m p r e s a ) ' ) 
 f r o m   c t e   w h e r e   c l i e n t e   =   @ c l i e n t e 
 i f   @ c t e m o d i f i c a r v e n c i m i e n t o   =   ' s i '   s e l e c t   @ m o d i f i c a r v e n c i m i e n t o   =   1   e l s e 
 i f   @ c t e m o d i f i c a r v e n c i m i e n t o   =   ' n o '   s e l e c t   @ m o d i f i c a r v e n c i m i e n t o   =   0 
 i f   n u l l i f ( @ c l i e n t e e n v i a r a ,   0 )   i s   n o t   n u l l 
 b e g i n 
 s e l e c t   @ e n v i a r a m o d i f i c a r v e n c i m i e n t o   =   r t r i m ( u p p e r ( m o d i f i c a r v e n c i m i e n t o ) ) 
 f r o m   c t e e n v i a r a   w h e r e   c l i e n t e   =   @ c l i e n t e   a n d   i d   =   @ c l i e n t e e n v i a r a 
 i f   @ e n v i a r a m o d i f i c a r v e n c i m i e n t o   =   ' s i '   s e l e c t   @ m o d i f i c a r v e n c i m i e n t o   =   1   e l s e 
 i f   @ e n v i a r a m o d i f i c a r v e n c i m i e n t o   =   ' n o '   s e l e c t   @ m o d i f i c a r v e n c i m i e n t o   =   0 
 e n d 
 i f   @ m o d i f i c a r v e n c i m i e n t o   =   1 
 e x e c   s p e m b a r q u e m o d i f i c a r v e n c i m i e n t o   @ f e c h a h o r a ,   @ e m p r e s a ,   @ m o v m o d u l o i d ,   @ m o v m o v ,   @ m o v m o v i d ,   @ m o v c o n d i c i o n ,   @ m o v v e n c i m i e n t o ,   @ o k   o u t p u t 
 e n d 
 e n d   e l s e 
 i f   @ m o v m o d u l o   =   ' i n v '   s e l e c t   @ m o v e s t a t u s   =   e s t a t u s   f r o m   i n v   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' c o m s '   s e l e c t   @ m o v e s t a t u s   =   e s t a t u s   f r o m   c o m p r a   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' c x c '   s e l e c t   @ m o v e s t a t u s   =   e s t a t u s   f r o m   c x c   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' d i n '   s e l e c t   @ m o v e s t a t u s   =   e s t a t u s   f r o m   d i n e r o   w h e r e   i d   =   @ m o v m o d u l o i d 
 i f   ( ( @ a c c i o n   < >   ' c a n c e l a r '   a n d   ( @ e s t a d o t i p o   =   ' d e s e m b a r c a r ' ) )   o r   ( @ e s t a d o t i p o   =   ' c o b r o   p a r c i a l '   a n d   @ m o v t i p o   =   ' e m b . o c ' ) )   o r   ( @ a c c i o n   =   ' c a n c e l a r '   a n d   @ e s t a t u s   =   ' c o n c l u i d o '   a n d   @ e s t a d o t i p o   < >   ' d e s e m b a r c a r ' ) 
 b e g i n 
 u p d a t e   e m b a r q u e m o v   s e t   a s i g n a d o i d   =   n u l l   w h e r e   i d   =   @ e m b a r q u e m o v 
 e n d 
 i f   @ e s t a d o t i p o   =   ' e n t r e g a d o ' 
 b e g i n 
 i f   @ m o v m o v t i p o   i n   ( ' d i n . c h ' ,   ' d i n . c h e ' )   a n d   @ m o v e s t a t u s   =   ' p e n d i e n t e ' 
 e x e c   s p d i n e r o   @ m o v m o d u l o i d ,   @ m o v m o d u l o ,   ' a f e c t a r ' ,   ' t o d o ' ,   @ f e c h a r e g i s t r o ,   n u l l ,   @ u s u a r i o ,   1 ,   0 , 
 @ g e n e r a r m o v ,   @ g e n e r a r m o v i d ,   @ i d g e n e r a r , 
 @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e n d 
 i f   @ e s t a d o t i p o   i n   ( ' c o b r a d o ' ,   ' c o b r o   p a r c i a l ' ,   ' p a g a d o ' ) 
 b e g i n 
 s e l e c t   @ c l i e n t e p r o v e e d o r   =   n u l l 
 i f   @ e s t a d o t i p o   i n   ( ' c o b r a d o ' ,   ' c o b r o   p a r c i a l ' ) 
 b e g i n 
 s e l e c t   @ c l i e n t e p r o v e e d o r   =   @ c l i e n t e 
 i f   @ c f g a f e c t a r c o b r o s   =   0   a n d   @ a c c i o n   < >   ' c a n c e l a r '   s e l e c t   @ g e n e r a r a c c i o n   =   ' g e n e r a r ' 
 e n d   e l s e 
 i f   @ e s t a d o t i p o   =   ' p a g a d o '   s e l e c t   @ c l i e n t e p r o v e e d o r   =   @ p r o v e e d o r 
 i f   @ c l i e n t e p r o v e e d o r   i s   n o t   n u l l 
 b e g i n 
 i f   @ i m p o r t e > @ m o v i m p o r t e   s e l e c t   @ a p l i c a i m p o r t e   =   i s n u l l ( @ m o v i m p o r t e ,   0 . 0 )   +   i s n u l l ( @ m o v i m p u e s t o s ,   0 . 0 )   e l s e   s e l e c t   @ a p l i c a i m p o r t e   =   @ i m p o r t e 
 e x e c   s p g e n e r a r c x   @ s u c u r s a l ,   @ s u c u r s a l o r i g e n ,   @ s u c u r s a l d e s t i n o ,   @ g e n e r a r a c c i o n ,   n u l l ,   @ e m p r e s a ,   @ m o d u l o ,   @ i d ,   @ m o v ,   @ m o v i d ,   n u l l ,   @ m o v m o n e d a ,   @ m o v t i p o c a m b i o , 
 @ f e c h a e m i s i o n ,   n u l l ,   @ p r o y e c t o ,   @ u s u a r i o ,   n u l l , 
 @ d e t a l l e r e f e r e n c i a ,   n u l l ,   n u l l ,   @ f e c h a r e g i s t r o ,   @ e j e r c i c i o ,   @ p e r i o d o , 
 n u l l ,   n u l l ,   @ c l i e n t e p r o v e e d o r ,   @ c l i e n t e e n v i a r a ,   @ a g e n t e ,   @ e s t a d o ,   @ c t a d i n e r o ,   @ f o r m a , 
 @ i m p o r t e ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   @ m o v m o v ,   @ m o v m o v i d ,   @ a p l i c a i m p o r t e ,   n u l l ,   n u l l , 
 @ g e n e r a r m o d u l o ,   @ g e n e r a r m o v ,   @ g e n e r a r m o v i d , 
 @ o k   o u t p u t ,   @ o k r e f   o u t p u t ,   @ p e r s o n a l c o b r a d o r   =   @ p e r s o n a l c o b r a d o r 
 e n d 
 e n d 
 i f   @ o k   =   8 0 0 3 0   s e l e c t   @ o k   =   n u l l ,   @ o k r e f   =   n u l l 
 i f   @ e s t a d o t i p o   i n   ( ' e n t r e g a d o ' ,   ' c o b r a d o ' )   a n d   @ a c c i o n   < >   ' c a n c e l a r ' 
 b e g i n 
 i f   @ m o v m o d u l o   =   ' v t a s '   u p d a t e   v e n t a   s e t   f e c h a e n t r e g a   =   @ f e c h a h o r a   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' c o m s '   u p d a t e   c o m p r a   s e t   f e c h a e n t r e g a   =   @ f e c h a h o r a   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' i n v '   u p d a t e   i n v   s e t   f e c h a e n t r e g a   =   @ f e c h a h o r a   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' c x c '   u p d a t e   c x c   s e t   f e c h a e n t r e g a   =   @ f e c h a h o r a   w h e r e   i d   =   @ m o v m o d u l o i d   e l s e 
 i f   @ m o v m o d u l o   =   ' d i n '   u p d a t e   d i n e r o   s e t   f e c h a e n t r e g a   =   @ f e c h a h o r a   w h e r e   i d   =   @ m o v m o d u l o i d 
 e n d 
 e n d   e l s e 
 b e g i n 
 e x e c   s p m o v f l u j o   @ s u c u r s a l ,   @ a c c i o n ,   @ e m p r e s a ,   @ m o v m o d u l o ,   @ m o v m o d u l o i d ,   @ m o v m o v ,   @ m o v m o v i d ,   @ m o d u l o ,   @ i d ,   @ m o v ,   @ m o v i d ,   @ o k   o u t p u t 
 i f   @ a c c i o n   =   ' c a n c e l a r ' 
 u p d a t e   e m b a r q u e m o v   s e t   a s i g n a d o i d   =   @ a n t e c e d e n t e i d   w h e r e   i d   =   @ e m b a r q u e m o v 
 e n d 
 e n d 
 i f   @ t i e n e p e n d i e n t e s   =   1   a n d   @ e s t a d o t i p o   n o t   i n   ( ' p e n d i e n t e ' ,   n u l l ,   ' ' ) 
 u p d a t e   e m b a r q u e d   s e t   d e s e m b a r q u e p a r c i a l   =   1 
 w h e r e   c u r r e n t   o f   c r e m b a r q u e 
 s e l e c t   @ s u m a p e s o   =   @ s u m a p e s o   +   @ p e s o , 
 @ s u m a v o l u m e n   =   @ s u m a v o l u m e n   +   @ v o l u m e n , 
 @ s u m a p a q u e t e s   =   @ s u m a p a q u e t e s   +   @ p a q u e t e s , 
 @ s u m a i m p o r t e p e s o s   =   @ s u m a i m p o r t e p e s o s   +   ( @ m o v i m p o r t e   *   @ m o v t i p o c a m b i o ) , 
 @ s u m a i m p u e s t o s p e s o s   =   @ s u m a i m p u e s t o s p e s o s   +   ( @ m o v i m p u e s t o s   *   @ m o v t i p o c a m b i o ) , 
 @ s u m a i m p o r t e e m b a r q u e =   @ s u m a i m p o r t e e m b a r q u e +   ( ( ( i s n u l l ( @ m o v i m p o r t e ,   0 ) + i s n u l l ( @ m o v i m p u e s t o s ,   0 ) ) * @ m o v t i p o c a m b i o ) ) * ( @ m o v p o r c e n t a j e / 1 0 0 ) 
 e n d 
 f e t c h   n e x t   f r o m   c r e m b a r q u e   i n t o   @ e m b a r q u e m o v ,   @ e s t a d o ,   @ f e c h a h o r a ,   @ f o r m a ,   @ i m p o r t e ,   @ d e t a l l e r e f e r e n c i a ,   @ d e t a l l e o b s e r v a c i o n e s ,   @ e m b a r q u e m o v i d ,   @ m o v m o d u l o ,   @ m o v m o d u l o i d ,   @ m o v m o v ,   @ m o v m o v i d ,   @ m o v i m p o r t e ,   @ m o v i m p u e s t o s ,   @ m o v m o n e d a ,   @ m o v t i p o c a m b i o ,   @ p e s o ,   @ v o l u m e n ,   @ p a q u e t e s ,   @ c l i e n t e ,   @ p r o v e e d o r ,   @ c l i e n t e e n v i a r a ,   @ e s t a d o t i p o ,   @ m o v p o r c e n t a j e 
 i f   @ @ e r r o r   < >   0   s e l e c t   @ o k   =   1 
 e n d 
 c l o s e   c r e m b a r q u e 
 d e a l l o c a t e   c r e m b a r q u e 
 i f   @ c f g g a s t o t a r i f a   =   1   a n d   @ e s t a t u s n u e v o   =   ' c o n c l u i d o '   a n d   @ a c c i o n   < >   ' c a n c e l a r '   a n d   @ o k   i s   n u l l 
 b e g i n 
 e x e c   s p g a s t o a n e x o t a r i f a   @ s u c u r s a l ,   @ e m p r e s a ,   @ m o d u l o ,   @ i d ,   @ m o v ,   @ m o v i d ,   @ f e c h a e m i s i o n ,   @ f e c h a r e g i s t r o ,   @ u s u a r i o ,   @ c f g a f e c t a r g a s t o t a r i f a ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e n d 
 i f   ( @ e s t a t u s n u e v o   =   ' c o n c l u i d o '   o r   @ a c c i o n   =   ' c a n c e l a r ' )   a n d   @ o k   i s   n u l l 
 b e g i n 
 e x e c   s p g a s t o a n e x o   @ e m p r e s a ,   @ m o d u l o ,   @ i d ,   @ a c c i o n ,   @ f e c h a r e g i s t r o ,   @ u s u a r i o ,   @ g a s t o a n e x o t o t a l p e s o s   o u t p u t ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 e x e c   s p g a s t o a n e x o e l i m i n a r   @ e m p r e s a ,   @ m o d u l o ,   @ i d 
 e n d 
 i f   @ o k   i s   n u l l 
 b e g i n 
 i f   @ t i e n e p e n d i e n t e s   =   1 
 u p d a t e   e m b a r q u e   s e t   e s t a t u s   =   @ e s t a t u s n u e v o , 
 u l t i m o c a m b i o   =   @ f e c h a r e g i s t r o 
 w h e r e   i d   =   @ i d 
 e l s e   b e g i n 
 i f   @ e s t a t u s n u e v o   =   ' c a n c e l a d o '   s e l e c t   @ f e c h a c a n c e l a c i o n   =   @ f e c h a r e g i s t r o   e l s e   s e l e c t   @ f e c h a c a n c e l a c i o n   =   n u l l 
 i f   @ e s t a t u s n u e v o   =   ' c o n c l u i d o '   s e l e c t   @ f e c h a c o n c l u s i o n   =   @ f e c h a r e g i s t r o   e l s e   i f   @ e s t a t u s n u e v o   < >   ' c a n c e l a d o '   s e l e c t   @ f e c h a c o n c l u s i o n   =   n u l l 
 i f   @ e s t a t u s n u e v o   =   ' c o n c l u i d o '   a n d   @ f e c h a r e t o r n o   i s   n u l l   s e l e c t   @ f e c h a r e t o r n o   =   @ f e c h a r e g i s t r o 
 s e l e c t   @ d i a r e t o r n o   =   @ f e c h a r e t o r n o 
 e x e c   s p e x t r a e r f e c h a   @ d i a r e t o r n o   o u t p u t 
 i f   @ c f g c o n t x   =   1   a n d   @ c f g c o n t x g e n e r a r   < >   ' n o ' 
 b e g i n 
 i f   @ e s t a t u s   =   ' s i n a f e c t a r '   a n d   @ e s t a t u s n u e v o   < >   ' c a n c e l a d o '   s e l e c t   @ g e n e r a r p o l i z a   =   1   e l s e 
 i f   @ e s t a t u s   < >   ' s i n a f e c t a r '   a n d   @ e s t a t u s n u e v o   =   ' c a n c e l a d o '   i f   @ g e n e r a r p o l i z a   =   1   s e l e c t   @ g e n e r a r p o l i z a   =   0   e l s e   s e l e c t   @ g e n e r a r p o l i z a   =   1 
 e n d 
 e x e c   s p v a l i d a r t a r e a s   @ e m p r e s a ,   @ m o d u l o ,   @ i d ,   @ e s t a t u s n u e v o ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 u p d a t e   e m b a r q u e   s e t   p e s o   =   n u l l i f ( @ s u m a p e s o ,   0 . 0 ) , 
 v o l u m e n   =   n u l l i f ( @ s u m a v o l u m e n ,   0 . 0 ) , 
 p a q u e t e s   =   n u l l i f ( @ s u m a p a q u e t e s ,   0 . 0 ) , 
 i m p o r t e   =   n u l l i f ( @ s u m a i m p o r t e p e s o s ,   0 . 0 ) , 
 i m p u e s t o s   =   n u l l i f ( @ s u m a i m p u e s t o s p e s o s ,   0 . 0 ) , 
 i m p o r t e e m b a r q u e   =   n u l l i f ( @ s u m a i m p o r t e e m b a r q u e ,   0 . 0 ) , 
 g a s t o s   =   n u l l i f ( @ g a s t o a n e x o t o t a l p e s o s ,   0 . 0 ) , 
 f e c h a s a l i d a   =   @ f e c h a s a l i d a , 
 f e c h a r e t o r n o   =   @ f e c h a r e t o r n o , 
 d i a r e t o r n o   =   @ d i a r e t o r n o , 
 f e c h a c o n c l u s i o n   =   @ f e c h a c o n c l u s i o n , 
 f e c h a c a n c e l a c i o n   =   @ f e c h a c a n c e l a c i o n , 
 u l t i m o c a m b i o   =   @ f e c h a r e g i s t r o   , 
 e s t a t u s   =   @ e s t a t u s n u e v o , 
 s i t u a c i o n   =   c a s e   w h e n   @ e s t a t u s < > @ e s t a t u s n u e v o   t h e n   n u l l   e l s e   s i t u a c i o n   e n d , 
 g e n e r a r p o l i z a   =   @ g e n e r a r p o l i z a 
 w h e r e   i d   =   @ i d 
 i f   @ @ e r r o r   < >   0   s e l e c t   @ o k   =   1 
 e n d 
 i f   @ e s t a t u s n u e v o   =   ' c o n c l u i d o ' 
 b e g i n 
 u p d a t e   e m b a r q u e d   s e t   d e s e m b a r q u e p a r c i a l   =   0   w h e r e   i d   =   @ i d   a n d   d e s e m b a r q u e p a r c i a l   =   1 
 u p d a t e   e m b a r q u e m o v   s e t   g a s t o s   =   i s n u l l ( g a s t o s ,   0 )   +   ( ( ( e . i m p o r t e + e . i m p u e s t o s ) * e . t i p o c a m b i o )   *   @ g a s t o a n e x o t o t a l p e s o s )   /   ( @ s u m a i m p o r t e p e s o s   +   @ s u m a i m p u e s t o s p e s o s ) 
 f r o m   e m b a r q u e m o v   e ,   e m b a r q u e d   d   w h e r e   d . i d   =   @ i d   a n d   d . e m b a r q u e m o v   =   e . i d 
 u p d a t e   e m b a r q u e m o v   s e t   c o n c l u i d o   =   1 
 w h e r e   a s i g n a d o i d   =   @ i d 
 i f   @ c f g b a s e p r o r r a t e o   =   ' i m p o r t e ' 
 u p d a t e   v e n t a   s e t   e m b a r q u e g a s t o s   =   i s n u l l ( e m b a r q u e g a s t o s ,   0 )   +   ( ( ( e . i m p o r t e + e . i m p u e s t o s ) * e . t i p o c a m b i o )   *   @ g a s t o a n e x o t o t a l p e s o s )   /   ( @ s u m a i m p o r t e p e s o s   +   @ s u m a i m p u e s t o s p e s o s ) 
 f r o m   e m b a r q u e m o v   e   ,   e m b a r q u e d   d   ,   v e n t a   v 
 w h e r e   d . i d   =   @ i d   a n d   d . e m b a r q u e m o v   =   e . i d   a n d   e . m o d u l o   =   ' v t a s '   a n d   e . m o d u l o i d   =   v . i d 
 e l s e 
 i f   @ c f g b a s e p r o r r a t e o   =   ' p a q u e t e s ' 
 u p d a t e   v e n t a   s e t   e m b a r q u e g a s t o s   =   i s n u l l ( e m b a r q u e g a s t o s ,   0 )   +   ( e . p a q u e t e s   *   @ g a s t o a n e x o t o t a l p e s o s )   /   @ s u m a p a q u e t e s 
 f r o m   e m b a r q u e m o v   e   ,   e m b a r q u e d   d   ,   v e n t a   v 
 w h e r e   d . i d   =   @ i d   a n d   d . e m b a r q u e m o v   =   e . i d   a n d   e . m o d u l o   =   ' v t a s '   a n d   e . m o d u l o i d   =   v . i d 
 e l s e 
 i f   @ c f g b a s e p r o r r a t e o   =   ' p e s o ' 
 u p d a t e   v e n t a   s e t   e m b a r q u e g a s t o s   =   i s n u l l ( e m b a r q u e g a s t o s ,   0 )   +   ( e . p e s o   *   @ g a s t o a n e x o t o t a l p e s o s )   /   @ s u m a p e s o 
 f r o m   e m b a r q u e m o v   e   ,   e m b a r q u e d   d   ,   v e n t a   v 
 w h e r e   d . i d   =   @ i d   a n d   d . e m b a r q u e m o v   =   e . i d   a n d   e . m o d u l o   =   ' v t a s '   a n d   e . m o d u l o i d   =   v . i d 
 e l s e 
 i f   @ c f g b a s e p r o r r a t e o   =   ' v o l u m e n ' 
 u p d a t e   v e n t a   s e t   e m b a r q u e g a s t o s   =   i s n u l l ( e m b a r q u e g a s t o s ,   0 )   +   ( e . v o l u m e n   *   @ g a s t o a n e x o t o t a l p e s o s )   /   @ s u m a v o l u m e n 
 f r o m   e m b a r q u e m o v   e   ,   e m b a r q u e d   d   ,   v e n t a   v 
 w h e r e   d . i d   =   @ i d   a n d   d . e m b a r q u e m o v   =   e . i d   a n d   e . m o d u l o   =   ' v t a s '   a n d   e . m o d u l o i d   =   v . i d 
 e l s e 
 i f   @ c f g b a s e p r o r r a t e o   =   ' p e s o / v o l u m e n ' 
 u p d a t e   v e n t a   s e t   e m b a r q u e g a s t o s   =   i s n u l l ( e m b a r q u e g a s t o s ,   0 )   +   ( ( ( i s n u l l ( e . p e s o ,   0 ) * i s n u l l ( e . v o l u m e n ,   0 ) ) * e . t i p o c a m b i o )   *   @ g a s t o a n e x o t o t a l p e s o s )   /   ( @ s u m a p e s o   *   @ s u m a v o l u m e n ) 
 f r o m   e m b a r q u e m o v   e   ,   e m b a r q u e d   d   ,   v e n t a   v 
 w h e r e   d . i d   =   @ i d   a n d   d . e m b a r q u e m o v   =   e . i d   a n d   e . m o d u l o   =   ' v t a s '   a n d   e . m o d u l o i d   =   v . i d 
 e n d 
 u p d a t e   v e h i c u l o   s e t   e s t a t u s   =   c a s e   w h e n   @ e s t a t u s n u e v o   =   ' p e n d i e n t e '   t h e n   ' e n t r a n s i t o '   e l s e   ' d i s p o n i b l e '   e n d 
 w h e r e   v e h i c u l o   =   @ v e h i c u l o 
 i f   @ @ e r r o r   < >   0   s e l e c t   @ o k   =   1 
 e n d 
 i f   @ v e h i c u l o   i s   n o t   n u l l 
 b e g i n 
 i f   ( s e l e c t   t i e n e m o v i m i e n t o s   f r o m   v e h i c u l o   w h e r e   v e h i c u l o   =   @ v e h i c u l o )   =   0 
 u p d a t e   v e h i c u l o   s e t   t i e n e m o v i m i e n t o s   =   1   w h e r e   v e h i c u l o   =   @ v e h i c u l o 
 e n d 
 i f   @ o k   i s   n u l l   o r   @ o k   b e t w e e n   8 0 0 3 0   a n d   8 1 0 0 0 
 e x e c   s p m o v f i n a l   @ e m p r e s a ,   @ s u c u r s a l ,   @ m o d u l o ,   @ i d ,   @ e s t a t u s ,   @ e s t a t u s n u e v o ,   @ u s u a r i o ,   @ f e c h a e m i s i o n ,   @ f e c h a r e g i s t r o ,   @ m o v ,   @ m o v i d ,   @ m o v t i p o ,   @ i d g e n e r a r ,   @ o k   o u t p u t ,   @ o k r e f   o u t p u t 
 i f   @ a c c i o n   =   ' c a n c e l a r '   a n d   @ e s t a t u s n u e v o   =   ' c a n c e l a d o '   a n d   @ o k   i s   n u l l 
 e x e c   s p c a n c e l a r f l u j o   @ e m p r e s a ,   @ m o d u l o ,   @ i d ,   @ o k   o u t p u t 
 i f   @ c o n e x i o n   =   0 
 i f   @ o k   i s   n u l l   o r   @ o k   b e t w e e n   8 0 0 3 0   a n d   8 1 0 0 0 
 c o m m i t   t r a n s a c t i o n 
 e l s e 
 r o l l b a c k   t r a n s a c t i o n 
 r e t u r n 
 e n d 