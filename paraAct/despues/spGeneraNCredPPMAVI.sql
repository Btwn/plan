u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p g e n e r a n c r e d p p m a v i ]   @ i d   i n t , 
 @ u s u a r i o   v a r c h a r ( 1 0 ) , 
 @ o k   i n t   o u t p u t , 
 @ o k r e f   v a r c h a r ( 2 5 5 )   o u t p u t 
 a s 
 b e g i n 
 d e c l a r e   @ e m p r e s a   c h a r ( 5 ) , 
 @ s u c u r s a l   i n t , 
 @ h o y   d a t e t i m e , 
 @ v e n c i m i e n t o   d a t e t i m e , 
 @ m o n e d a   c h a r ( 1 0 ) , 
 @ t i p o c a m b i o   f l o a t , 
 @ c o n t a c t o   c h a r ( 1 0 ) , 
 @ r e n g l o n   f l o a t , 
 @ a p l i c a   v a r c h a r ( 2 0 ) , 
 @ a p l i c a i d   v a r c h a r ( 2 0 ) , 
 @ i m p r e a l   m o n e y , 
 @ m o r a t o r i o a p a g a r   m o n e y , 
 @ o r i g e n   v a r c h a r ( 2 0 ) , 
 @ o r i g e n i d   v a r c h a r ( 2 0 ) , 
 @ m o v p a d r e   v a r c h a r ( 2 0 ) , 
 @ m o v p a d r e 1   v a r c h a r ( 2 0 ) , 
 @ m o v i d p a d r e   v a r c h a r ( 2 0 ) , 
 @ p a p u n t u a l   m o n e y , 
 @ u e n   i n t , 
 @ m o v c r e a r   v a r c h a r ( 2 0 ) , 
 @ m o v   v a r c h a r ( 2 0 ) , 
 @ i d c x c   i n t , 
 @ f e c h a a p l i c a c i o n   d a t e t i m e , 
 @ c t a d i n e r o   v a r c h a r ( 1 0 ) , 
 @ c o n c e p t o   v a r c h a r ( 5 0 ) , 
 @ i d p o l   i n t , 
 @ n u m d o c t o s   i n t , 
 @ i m p d o c t o   m o n e y , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ t o t a l m o v   m o n e y , 
 @ r e f e r e n c i a   v a r c h a r ( 1 0 0 ) , 
 @ c a n a l v e n t a   i n t , 
 @ i m p u e s t o s   m o n e y , 
 @ h a y n o t a s c r e d c a n c   i n t , 
 @ d o c s p e n d   i n t , 
 @ s d o d o c   m o n e y , 
 @ i m p t o t a l b o n i f   m o n e y , 
 @ d e f i m p u e s t o   f l o a t , 
 @ i d c x c 2   i n t , 
 @ m i n b o n   i n t , 
 @ m a x b o n   i n t , 
 @ m i n d e t   i n t , 
 @ m a x d e t   i n t , 
 @ m i n b o n 2   i n t , 
 @ m a x b o n 2   i n t , 
 @ m i n d e t 2   i n t , 
 @ m a x d e t 2   i n t 
 s e t   @ d o c s p e n d   =   0 
 s e t   @ f e c h a a p l i c a c i o n   =   g e t d a t e ( ) 
 s e l e c t 
 @ e m p r e s a   =   e m p r e s a , 
 @ s u c u r s a l   =   s u c u r s a l , 
 @ h o y   =   f e c h a e m i s i o n , 
 @ m o n e d a   =   m o n e d a , 
 @ t i p o c a m b i o   =   t i p o c a m b i o , 
 @ c o n t a c t o   =   c l i e n t e 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 s e l e c t 
 @ h a y n o t a s c r e d c a n c   =   c o u n t ( i d ) 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 a n d   n o t a c r e d i t o x c a n c   =   ' 1 ' 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r g e n b o n i f p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r g e n b o n i f p 
 c r e a t e   t a b l e   # c r g e n b o n i f p   ( 
 i d   i n t   p r i m a r y   k e y   i d e n t i t y   ( 1 ,   1 )   n o t   n u l l , 
 p a p u n t u a l   m o n e y   n u l l , 
 o r i g e n   v a r c h a r ( 2 5 )   n u l l , 
 o r i g e n i d   v a r c h a r ( 2 5 )   n u l l , 
 i d p a p u n t u a l   i n t   n u l l 
 ) 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r d e t n c b o n i f p p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r d e t n c b o n i f p p 
 c r e a t e   t a b l e   # c r d e t n c b o n i f p p   ( 
 i d   i n t   p r i m a r y   k e y   i d e n t i t y   ( 1 ,   1 )   n o t   n u l l , 
 m o v   v a r c h a r ( 2 5 )   n u l l , 
 m o v i d   v a r c h a r ( 2 5 )   n u l l , 
 p a p u n t u a l   m o n e y   n u l l 
 ) 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r g e n b o n i f p p 2 ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r g e n b o n i f p p 2 
 c r e a t e   t a b l e   # c r g e n b o n i f p p 2   ( 
 i d   i n t   p r i m a r y   k e y   i d e n t i t y   ( 1 ,   1 )   n o t   n u l l , 
 p a p u n t u a l   m o n e y   n u l l , 
 o r i g e n   v a r c h a r ( 2 5 )   n u l l , 
 o r i g e n i d   v a r c h a r ( 2 5 )   n u l l , 
 i d p a p u n t u a l   i n t   n u l l 
 ) 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r d e t n c b o n i f p p 2 ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r d e t n c b o n i f p p 2 
 c r e a t e   t a b l e   # c r d e t n c b o n i f p p 2   ( 
 i d   i n t   p r i m a r y   k e y   i d e n t i t y   ( 1 ,   1 )   n o t   n u l l , 
 m o v   v a r c h a r ( 2 5 )   n u l l , 
 m o v i d   v a r c h a r ( 2 5 )   n u l l , 
 p a p u n t u a l   m o n e y   n u l l 
 ) 
 i f   @ h a y n o t a s c r e d c a n c   =   0 
 b e g i n 
 i n s e r t   i n t o   # c r g e n b o n i f p   ( p a p u n t u a l ,   o r i g e n ,   o r i g e n i d ,   i d p a p u n t u a l ) 
 s e l e c t 
 s u m ( i s n u l l ( p a p u n t u a l ,   0 ) ) , 
 o r i g e n , 
 o r i g e n i d , 
 i d p a p u n t u a l 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 g r o u p   b y   o r i g e n , 
 o r i g e n i d , 
 i d p a p u n t u a l 
 s e l e c t 
 @ m i n b o n   =   m i n ( i d ) , 
 @ m a x b o n   =   m a x ( i d ) 
 f r o m   # c r g e n b o n i f p 
 w h i l e   @ m i n b o n   < =   @ m a x b o n 
 b e g i n 
 s e l e c t 
 @ p a p u n t u a l   =   p a p u n t u a l , 
 @ o r i g e n   =   o r i g e n , 
 @ o r i g e n i d   =   o r i g e n i d , 
 @ i d p o l   =   i d p a p u n t u a l 
 f r o m   # c r g e n b o n i f p 
 w h e r e   i d   =   @ m i n b o n 
 s e t   @ i m p t o t a l b o n i f   =   @ p a p u n t u a l 
 s e t   @ r e n g l o n   =   1 0 2 4 . 0 
 s e l e c t 
 @ u e n   =   u e n , 
 @ c a n a l v e n t a   =   c l i e n t e e n v i a r a 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ o r i g e n 
 a n d   m o v i d   =   @ o r i g e n i d 
 s e l e c t 
 @ m o v p a d r e   =   @ o r i g e n 
 s e l e c t 
 @ m o v c r e a r   =   i s n u l l ( m o v c r e a r ,   ' n o t a   c r e d i t o ' ) 
 f r o m   m o v c r e a r b o n i f m a v i   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ m o v p a d r e 
 a n d   u e n   =   @ u e n 
 i f   @ m o v c r e a r   i s   n u l l 
 s e l e c t 
 @ m o v c r e a r   =   ' n o t a   c r e d i t o ' 
 s e l e c t 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   m a v i b o n i f i c a c i o n c o n f   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d p o l 
 s e l e c t 
 @ d o c s p e n d   =   c o u n t ( * ) 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   p a d r e m a v i   =   @ o r i g e n 
 a n d   p a d r e i d m a v i   =   @ o r i g e n i d 
 a n d   e s t a t u s   =   ' p e n d i e n t e ' 
 i f   @ d o c s p e n d   >   0 
 b e g i n 
 i n s e r t   i n t o   c x c   ( e m p r e s a ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   u l t i m o c a m b i o ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   a u t o r i z a c i o n ,   r e f e r e n c i a ,   d o c f u e n t e , 
 o b s e r v a c i o n e s ,   e s t a t u s ,   s i t u a c i o n ,   s i t u a c i o n f e c h a ,   s i t u a c i o n u s u a r i o ,   s i t u a c i o n n o t a ,   c l i e n t e ,   c l i e n t e e n v i a r a ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o , 
 c o b r a d o r ,   c o n d i c i o n ,   v e n c i m i e n t o ,   f o r m a c o b r o ,   c t a d i n e r o ,   i m p o r t e ,   i m p u e s t o s ,   r e t e n c i o n ,   a p l i c a m a n u a l ,   c o n d e s g l o s e ,   f o r m a c o b r o 1 ,   f o r m a c o b r o 2 , 
 f o r m a c o b r o 3 ,   f o r m a c o b r o 4 ,   f o r m a c o b r o 5 ,   r e f e r e n c i a 1 ,   r e f e r e n c i a 2 ,   r e f e r e n c i a 3 ,   r e f e r e n c i a 4 ,   r e f e r e n c i a 5 ,   i m p o r t e 1 ,   i m p o r t e 2 ,   i m p o r t e 3 , 
 i m p o r t e 4 ,   i m p o r t e 5 ,   c a m b i o ,   d e l e f e c t i v o ,   a g e n t e ,   c o m i s i o n t o t a l ,   c o m i s i o n p e n d i e n t e ,   m o v a p l i c a ,   m o v a p l i c a i d ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d , 
 p o l i z a ,   p o l i z a i d ,   f e c h a c o n c l u s i o n ,   f e c h a c a n c e l a c i o n ,   d i n e r o ,   d i n e r o i d ,   d i n e r o c t a d i n e r o ,   c o n t r a m i t e s ,   v i n ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   c a j e r o , 
 u e n ,   p e r s o n a l c o b r a d o r ,   f e c h a o r i g i n a l ,   n o t a ,   c o m e n t a r i o s ,   l i n e a c r e d i t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   a m o r t i z a c i o n e s ,   c o m i s i o n e s ,   c o m i s i o n e s i v a , 
 f e c h a r e v i s i o n ,   c o n t u s o ,   t i e n e t a s a e s p ,   t a s a e s p ,   c o d i ) 
 v a l u e s   ( @ e m p r e s a ,   @ m o v c r e a r ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   @ f e c h a a p l i c a c i o n ,   @ c o n c e p t o ,   n u l l ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   n u l l ,   @ r e f e r e n c i a ,   n u l l , 
 n u l l ,   ' s i n a f e c t a r ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   @ c o n t a c t o ,   @ c a n a l v e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o , 
 n u l l ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   n u l l ,   @ c t a d i n e r o ,   n u l l ,   n u l l ,   n u l l ,   1 ,   0 ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   @ u e n ,   n u l l ,   n u l l ,   n u l l ,   ' ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   n u l l ) 
 s e l e c t 
 @ i d c x c   =   @ @ i d e n t i t y 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k ) 
 s e t   n o t a c r e d b o n i d   =   @ i d c x c 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   o r i g e n   =   @ o r i g e n 
 a n d   o r i g e n i d   =   @ o r i g e n i d 
 a n d   i d p a p u n t u a l   =   @ i d p o l 
 i n s e r t   i n t o   # c r d e t n c b o n i f p p   ( m o v ,   m o v i d ,   p a p u n t u a l ) 
 s e l e c t 
 m o v , 
 m o v i d , 
 c a s e 
 w h e n   p a p u n t u a l   >   b o n i f i c a c i o n   t h e n   b o n i f i c a c i o n 
 e l s e   p a p u n t u a l 
 e n d 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 a n d   o r i g e n   =   @ o r i g e n 
 a n d   o r i g e n i d   =   @ o r i g e n i d 
 s e l e c t 
 @ m i n d e t   =   m i n ( i d ) , 
 @ m a x d e t   =   m a x ( i d ) 
 f r o m   # c r d e t n c b o n i f p p 
 w h i l e   @ m i n d e t   < =   @ m a x d e t 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ i m p d o c t o   =   p a p u n t u a l 
 f r o m   # c r d e t n c b o n i f p p 
 w h e r e   i d   =   @ m i n d e t 
 s e l e c t 
 @ s d o d o c   =   s a l d o 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ m o v 
 a n d   m o v i d   =   @ m o v i d 
 i f   @ i m p d o c t o   >   @ s d o d o c 
 b e g i n 
 s e l e c t 
 @ i m p d o c t o   =   @ s d o d o c 
 s e t   @ i m p t o t a l b o n i f   =   @ i m p t o t a l b o n i f   -   @ i m p d o c t o 
 i n s e r t   i n t o   c x c d   ( i d ,   r e n g l o n ,   r e n g l o n s u b ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ,   f e c h a ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   d e s c u e n t o r e c a r s ,   i n t e r e s e s o r d i n a r i o s , 
 i n t e r e s e s m o r a t o r i o s ,   i n t e r e s e s o r d i n a r i o s q u i t a ,   i n t e r e s e s m o r a t o r i o s q u i t a ,   i m p u e s t o a d i c i o n a l ,   r e t e n c i o n ) 
 v a l u e s   ( @ i d c x c ,   @ r e n g l o n ,   0 ,   @ m o v ,   @ m o v i d ,   @ i m p d o c t o ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ) 
 s e t   @ r e n g l o n   =   @ r e n g l o n   +   1 0 2 4 . 0 
 e n d 
 e l s e 
 b e g i n 
 i f   @ i m p d o c t o   < =   @ s d o d o c 
 b e g i n 
 s e t   @ i m p t o t a l b o n i f   =   @ i m p t o t a l b o n i f   -   @ i m p d o c t o 
 i n s e r t   i n t o   c x c d   ( i d ,   r e n g l o n ,   r e n g l o n s u b ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ,   f e c h a ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   d e s c u e n t o r e c a r s ,   i n t e r e s e s o r d i n a r i o s , 
 i n t e r e s e s m o r a t o r i o s ,   i n t e r e s e s o r d i n a r i o s q u i t a ,   i n t e r e s e s m o r a t o r i o s q u i t a ,   i m p u e s t o a d i c i o n a l ,   r e t e n c i o n ) 
 v a l u e s   ( @ i d c x c ,   @ r e n g l o n ,   0 ,   @ m o v ,   @ m o v i d ,   @ i m p d o c t o ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ) 
 s e t   @ r e n g l o n   =   @ r e n g l o n   +   1 0 2 4 . 0 
 e n d 
 e n d 
 s e t   @ m i n d e t   =   @ m i n d e t   +   1 
 e n d 
 s e l e c t 
 @ i m p u e s t o s   =   s u m ( d . i m p o r t e   *   i s n u l l ( c a . i v a f i s c a l ,   0 . 0 0 ) ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c a p l i c a   c a   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c a . m o v 
 a n d   d . a p l i c a i d   =   c a . m o v i d 
 a n d   c a . e m p r e s a   =   @ e m p r e s a 
 w h e r e   d . i d   =   @ i d c x c 
 s e l e c t 
 @ t o t a l m o v   =   s u m ( d . i m p o r t e   -   i s n u l l ( d . i m p o r t e   *   c a . i v a f i s c a l ,   0 ) ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c a p l i c a   c a   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c a . m o v 
 a n d   d . a p l i c a i d   =   c a . m o v i d 
 a n d   c a . e m p r e s a   =   @ e m p r e s a 
 w h e r e   d . i d   =   @ i d c x c 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   i m p o r t e   =   i s n u l l ( r o u n d ( @ t o t a l m o v ,   2 ) ,   0 . 0 0 ) , 
 i m p u e s t o s   =   i s n u l l ( r o u n d ( @ i m p u e s t o s ,   2 ) ,   0 . 0 0 ) , 
 s a l d o   =   i s n u l l ( r o u n d ( @ t o t a l m o v ,   2 ) ,   0 . 0 0 )   +   i s n u l l ( r o u n d ( @ i m p u e s t o s ,   2 ) ,   0 . 0 0 ) , 
 i d c o b r o b o n i f m a v i   =   @ i d 
 w h e r e   i d   =   @ i d c x c 
 e n d 
 i f   @ i d c x c   >   0 
 b e g i n 
 e x e c   s p a f e c t a r   ' c x c ' , 
 @ i d c x c , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 n u l l , 
 @ u s u a r i o , 
 n u l l , 
 1 , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 n u l l , 
 @ c o n e x i o n   =   1 
 i n s e r t   i n t o   d e t a l l e a f e c t a c i o n m a v i   ( i d c o b r o ,   i d ,   m o v ,   m o v i d ,   v a l o r o k ,   v a l o r o k r e f ) 
 v a l u e s   ( @ i d ,   @ i d c x c ,   @ m o v c r e a r ,   n u l l ,   @ o k ,   @ o k r e f ) 
 e n d 
 i f   @ i m p t o t a l b o n i f   >   0 
 b e g i n 
 s e l e c t 
 @ d e f i m p u e s t o   =   d e f i m p u e s t o 
 f r o m   e m p r e s a g r a l   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 i n s e r t   i n t o   c x c   ( e m p r e s a ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   u l t i m o c a m b i o ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   a u t o r i z a c i o n ,   r e f e r e n c i a ,   d o c f u e n t e , 
 o b s e r v a c i o n e s ,   e s t a t u s ,   s i t u a c i o n ,   s i t u a c i o n f e c h a ,   s i t u a c i o n u s u a r i o ,   s i t u a c i o n n o t a ,   c l i e n t e ,   c l i e n t e e n v i a r a ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o , 
 c o b r a d o r ,   c o n d i c i o n ,   v e n c i m i e n t o ,   f o r m a c o b r o ,   c t a d i n e r o ,   i m p o r t e ,   i m p u e s t o s ,   r e t e n c i o n ,   a p l i c a m a n u a l ,   c o n d e s g l o s e ,   f o r m a c o b r o 1 ,   f o r m a c o b r o 2 , 
 f o r m a c o b r o 3 ,   f o r m a c o b r o 4 ,   f o r m a c o b r o 5 ,   r e f e r e n c i a 1 ,   r e f e r e n c i a 2 ,   r e f e r e n c i a 3 ,   r e f e r e n c i a 4 ,   r e f e r e n c i a 5 ,   i m p o r t e 1 ,   i m p o r t e 2 ,   i m p o r t e 3 , 
 i m p o r t e 4 ,   i m p o r t e 5 ,   c a m b i o ,   d e l e f e c t i v o ,   a g e n t e ,   c o m i s i o n t o t a l ,   c o m i s i o n p e n d i e n t e ,   m o v a p l i c a ,   m o v a p l i c a i d ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d , 
 p o l i z a ,   p o l i z a i d ,   f e c h a c o n c l u s i o n ,   f e c h a c a n c e l a c i o n ,   d i n e r o ,   d i n e r o i d ,   d i n e r o c t a d i n e r o ,   c o n t r a m i t e s ,   v i n ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   c a j e r o , 
 u e n ,   p e r s o n a l c o b r a d o r ,   f e c h a o r i g i n a l ,   n o t a ,   c o m e n t a r i o s ,   l i n e a c r e d i t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   a m o r t i z a c i o n e s ,   c o m i s i o n e s ,   c o m i s i o n e s i v a , 
 f e c h a r e v i s i o n ,   c o n t u s o ,   t i e n e t a s a e s p ,   t a s a e s p ,   c o d i ) 
 v a l u e s   ( @ e m p r e s a ,   @ m o v c r e a r ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   @ f e c h a a p l i c a c i o n ,   @ c o n c e p t o ,   n u l l ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   n u l l ,   @ r e f e r e n c i a ,   n u l l , 
 n u l l ,   ' s i n a f e c t a r ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   @ c o n t a c t o ,   @ c a n a l v e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o , 
 n u l l ,   n u l l ,   @ f e c h a a p l i c a c i o n ,   n u l l ,   @ c t a d i n e r o ,   n u l l ,   n u l l ,   n u l l ,   0 ,   0 ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   @ u e n ,   n u l l ,   n u l l ,   n u l l ,   ' ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   n u l l ) 
 s e l e c t 
 @ i d c x c 2   =   @ @ i d e n t i t y 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   i m p o r t e   =   r o u n d ( @ i m p t o t a l b o n i f   /   ( 1   +   @ d e f i m p u e s t o   /   1 0 0 . 0 ) ,   2 ) , 
 i m p u e s t o s   =   r o u n d ( @ i m p t o t a l b o n i f   /   ( 1   +   @ d e f i m p u e s t o   /   1 0 0 . 0 ) ,   2 )   *   ( @ d e f i m p u e s t o   /   1 0 0 . 0 ) , 
 s a l d o   =   r o u n d ( @ i m p t o t a l b o n i f   /   ( 1   +   @ d e f i m p u e s t o   /   1 0 0 . 0 ) ,   2 )   +   r o u n d ( @ i m p t o t a l b o n i f   /   ( 1   +   @ d e f i m p u e s t o   /   1 0 0 . 0 ) ,   2 )   *   ( @ d e f i m p u e s t o   /   1 0 0 . 0 ) , 
 i d c o b r o b o n i f m a v i   =   @ i d 
 w h e r e   i d   =   @ i d c x c 2 
 e x e c   s p a f e c t a r   ' c x c ' , 
 @ i d c x c 2 , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 n u l l , 
 @ u s u a r i o , 
 n u l l , 
 1 , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 n u l l , 
 @ c o n e x i o n   =   1 
 i n s e r t   i n t o   d e t a l l e a f e c t a c i o n m a v i   ( i d c o b r o ,   i d ,   m o v ,   m o v i d ,   v a l o r o k ,   v a l o r o k r e f ) 
 v a l u e s   ( @ i d ,   @ i d c x c 2 ,   @ m o v c r e a r ,   n u l l ,   @ o k ,   @ o k r e f ) 
 e n d 
 s e t   @ m i n b o n   =   @ m i n b o n   +   1 
 e n d 
 e n d 
 e l s e 
 b e g i n 
 i n s e r t   i n t o   # c r g e n b o n i f p   ( p a p u n t u a l ,   o r i g e n ,   o r i g e n i d ,   i d p a p u n t u a l ) 
 s e l e c t 
 s u m ( i s n u l l ( p a p u n t u a l ,   0 ) ) , 
 o r i g e n , 
 o r i g e n i d , 
 i d p a p u n t u a l 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 a n d   n o t a c r e d i t o x c a n c   =   ' 1 ' 
 g r o u p   b y   o r i g e n , 
 o r i g e n i d , 
 i d p a p u n t u a l 
 s e l e c t 
 @ m i n b o n   =   m i n ( i d ) , 
 @ m a x b o n   =   m a x ( i d ) 
 f r o m   # c r g e n b o n i f p 
 w h i l e   @ m i n b o n   < =   @ m a x b o n 
 b e g i n 
 s e l e c t 
 @ p a p u n t u a l   =   p a p u n t u a l , 
 @ o r i g e n   =   o r i g e n , 
 @ o r i g e n i d   =   o r i g e n i d , 
 @ i d p o l   =   i d p a p u n t u a l 
 f r o m   # c r g e n b o n i f p 
 w h e r e   i d   =   @ m i n b o n 
 s e t   @ r e n g l o n   =   1 0 2 4 . 0 
 s e l e c t 
 @ u e n   =   u e n , 
 @ c a n a l v e n t a   =   c l i e n t e e n v i a r a 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ o r i g e n 
 a n d   m o v i d   =   @ o r i g e n i d 
 s e l e c t 
 @ m o v p a d r e   =   @ o r i g e n 
 s e l e c t 
 @ m o v c r e a r   =   i s n u l l ( m o v c r e a r ,   ' n o t a   c r e d i t o ' ) 
 f r o m   m o v c r e a r b o n i f m a v i   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ m o v p a d r e 
 a n d   u e n   =   @ u e n 
 i f   @ m o v p a d r e   =   ' c r e d i l a n a ' 
 s e t   @ m o v c r e a r   =   ' n o t a   c r e d i t o ' 
 i f   @ m o v p a d r e   =   ' p r e s t a m o   p e r s o n a l ' 
 s e t   @ m o v c r e a r   =   ' n o t a   c r e d i t o   v i u ' 
 i f   @ m o v c r e a r   i s   n u l l 
 s e l e c t 
 @ m o v c r e a r   =   ' n o t a   c r e d i t o ' 
 s e l e c t 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   m a v i b o n i f i c a c i o n c o n f   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d p o l 
 i n s e r t   i n t o   c x c   ( e m p r e s a ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   u l t i m o c a m b i o ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   a u t o r i z a c i o n ,   r e f e r e n c i a ,   d o c f u e n t e , 
 o b s e r v a c i o n e s ,   e s t a t u s ,   s i t u a c i o n ,   s i t u a c i o n f e c h a ,   s i t u a c i o n u s u a r i o ,   s i t u a c i o n n o t a ,   c l i e n t e ,   c l i e n t e e n v i a r a ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o , 
 c o b r a d o r ,   c o n d i c i o n ,   v e n c i m i e n t o ,   f o r m a c o b r o ,   c t a d i n e r o ,   i m p o r t e ,   i m p u e s t o s ,   r e t e n c i o n ,   a p l i c a m a n u a l ,   c o n d e s g l o s e ,   f o r m a c o b r o 1 ,   f o r m a c o b r o 2 , 
 f o r m a c o b r o 3 ,   f o r m a c o b r o 4 ,   f o r m a c o b r o 5 ,   r e f e r e n c i a 1 ,   r e f e r e n c i a 2 ,   r e f e r e n c i a 3 ,   r e f e r e n c i a 4 ,   r e f e r e n c i a 5 ,   i m p o r t e 1 ,   i m p o r t e 2 ,   i m p o r t e 3 , 
 i m p o r t e 4 ,   i m p o r t e 5 ,   c a m b i o ,   d e l e f e c t i v o ,   a g e n t e ,   c o m i s i o n t o t a l ,   c o m i s i o n p e n d i e n t e ,   m o v a p l i c a ,   m o v a p l i c a i d ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d , 
 p o l i z a ,   p o l i z a i d ,   f e c h a c o n c l u s i o n ,   f e c h a c a n c e l a c i o n ,   d i n e r o ,   d i n e r o i d ,   d i n e r o c t a d i n e r o ,   c o n t r a m i t e s ,   v i n ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   c a j e r o , 
 u e n ,   p e r s o n a l c o b r a d o r ,   f e c h a o r i g i n a l ,   n o t a ,   c o m e n t a r i o s ,   l i n e a c r e d i t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   a m o r t i z a c i o n e s ,   c o m i s i o n e s ,   c o m i s i o n e s i v a , 
 f e c h a r e v i s i o n ,   c o n t u s o ,   t i e n e t a s a e s p ,   t a s a e s p ,   c o d i ) 
 v a l u e s   ( @ e m p r e s a ,   @ m o v c r e a r ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   @ f e c h a a p l i c a c i o n ,   @ c o n c e p t o ,   n u l l ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   n u l l ,   @ r e f e r e n c i a ,   n u l l , 
 n u l l ,   ' s i n a f e c t a r ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   @ c o n t a c t o ,   @ c a n a l v e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o , 
 n u l l ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   n u l l ,   @ c t a d i n e r o ,   n u l l ,   n u l l ,   n u l l ,   1 ,   0 ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   @ u e n ,   n u l l ,   n u l l ,   n u l l ,   ' ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   n u l l ) 
 s e l e c t 
 @ i d c x c   =   @ @ i d e n t i t y 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k ) 
 s e t   n o t a c r e d b o n i d   =   @ i d c x c 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   o r i g e n   =   @ o r i g e n 
 a n d   o r i g e n i d   =   @ o r i g e n i d 
 a n d   i d p a p u n t u a l   =   @ i d p o l 
 a n d   n o t a c r e d i t o x c a n c   =   ' 1 ' 
 i n s e r t   i n t o   # c r d e t n c b o n i f p p   ( m o v ,   m o v i d ,   p a p u n t u a l ) 
 s e l e c t 
 m o v , 
 m o v i d , 
 c a s e 
 w h e n   p a p u n t u a l   >   b o n i f i c a c i o n   t h e n   b o n i f i c a c i o n 
 e l s e   p a p u n t u a l 
 e n d 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 a n d   n o t a c r e d i t o x c a n c   =   ' 1 ' 
 a n d   o r i g e n   =   @ o r i g e n 
 a n d   o r i g e n i d   =   @ o r i g e n i d 
 s e l e c t 
 @ m i n d e t   =   m i n ( i d ) , 
 @ m a x d e t   =   m a x ( i d ) 
 f r o m   # c r d e t n c b o n i f p p 
 w h i l e   @ m i n d e t   < =   @ m a x d e t 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ i m p d o c t o   =   p a p u n t u a l 
 f r o m   # c r d e t n c b o n i f p p 
 w h e r e   i d   =   @ m i n d e t 
 i n s e r t   i n t o   c x c d   ( i d ,   r e n g l o n ,   r e n g l o n s u b ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ,   f e c h a ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   d e s c u e n t o r e c a r s ,   i n t e r e s e s o r d i n a r i o s , 
 i n t e r e s e s m o r a t o r i o s ,   i n t e r e s e s o r d i n a r i o s q u i t a ,   i n t e r e s e s m o r a t o r i o s q u i t a ,   i m p u e s t o a d i c i o n a l ,   r e t e n c i o n ) 
 v a l u e s   ( @ i d c x c ,   @ r e n g l o n ,   0 ,   @ m o v ,   @ m o v i d ,   @ i m p d o c t o ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ) 
 s e t   @ r e n g l o n   =   @ r e n g l o n   +   1 0 2 4 . 0 
 s e t   @ m i n d e t   =   @ m i n d e t   +   1 
 e n d 
 s e l e c t 
 @ i m p u e s t o s   =   s u m ( d . i m p o r t e   *   i s n u l l ( c a . i v a f i s c a l ,   0 . 0 0 ) ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c a p l i c a   c a   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c a . m o v 
 a n d   d . a p l i c a i d   =   c a . m o v i d 
 a n d   c a . e m p r e s a   =   @ e m p r e s a 
 w h e r e   d . i d   =   @ i d c x c 
 s e l e c t 
 @ t o t a l m o v   =   s u m ( d . i m p o r t e   -   i s n u l l ( d . i m p o r t e   *   c a . i v a f i s c a l ,   0 ) ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c a p l i c a   c a   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c a . m o v 
 a n d   d . a p l i c a i d   =   c a . m o v i d 
 a n d   c a . e m p r e s a   =   @ e m p r e s a 
 w h e r e   d . i d   =   @ i d c x c 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   i m p o r t e   =   i s n u l l ( r o u n d ( @ t o t a l m o v ,   2 ) ,   0 . 0 0 ) , 
 i m p u e s t o s   =   i s n u l l ( r o u n d ( @ i m p u e s t o s ,   2 ) ,   0 . 0 0 ) , 
 s a l d o   =   i s n u l l ( r o u n d ( @ t o t a l m o v ,   2 ) ,   0 . 0 0 )   +   i s n u l l ( r o u n d ( @ i m p u e s t o s ,   2 ) ,   0 . 0 0 ) , 
 i d c o b r o b o n i f m a v i   =   @ i d 
 w h e r e   i d   =   @ i d c x c 
 e x e c   s p a f e c t a r   ' c x c ' , 
 @ i d c x c , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 n u l l , 
 @ u s u a r i o , 
 n u l l , 
 1 , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 n u l l , 
 @ c o n e x i o n   =   1 
 i n s e r t   i n t o   d e t a l l e a f e c t a c i o n m a v i   ( i d c o b r o ,   i d ,   m o v ,   m o v i d ,   v a l o r o k ,   v a l o r o k r e f ) 
 v a l u e s   ( @ i d ,   @ i d c x c ,   @ m o v c r e a r ,   n u l l ,   @ o k ,   @ o k r e f ) 
 s e t   @ m i n b o n   =   @ m i n b o n   +   1 
 e n d 
 i n s e r t   i n t o   # c r g e n b o n i f p p 2   ( p a p u n t u a l ,   o r i g e n ,   o r i g e n i d ,   i d p a p u n t u a l ) 
 s e l e c t 
 s u m ( i s n u l l ( p a p u n t u a l ,   0 ) ) , 
 o r i g e n , 
 o r i g e n i d , 
 i d p a p u n t u a l 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 a n d   n o t a c r e d i t o x c a n c   i s   n u l l 
 g r o u p   b y   o r i g e n , 
 o r i g e n i d , 
 i d p a p u n t u a l 
 s e l e c t 
 @ m i n b o n 2   =   m i n ( i d ) , 
 @ m a x b o n 2   =   m a x ( i d ) 
 f r o m   # c r g e n b o n i f p p 2 
 w h i l e   @ m i n b o n 2   < =   @ m a x b o n 2 
 b e g i n 
 s e l e c t 
 @ p a p u n t u a l   =   p a p u n t u a l , 
 @ o r i g e n   =   o r i g e n , 
 @ o r i g e n i d   =   o r i g e n i d , 
 @ i d p o l   =   i d p a p u n t u a l 
 f r o m   # c r g e n b o n i f p p 2 
 w h e r e   i d   =   @ m i n b o n 2 
 s e t   @ r e n g l o n   =   1 0 2 4 . 0 
 s e l e c t 
 @ u e n   =   u e n , 
 @ c a n a l v e n t a   =   c l i e n t e e n v i a r a 
 f r o m   c x c   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ o r i g e n 
 a n d   m o v i d   =   @ o r i g e n i d 
 s e l e c t 
 @ m o v p a d r e   =   @ o r i g e n 
 s e l e c t 
 @ m o v c r e a r   =   i s n u l l ( m o v c r e a r ,   ' n o t a   c r e d i t o ' ) 
 f r o m   m o v c r e a r b o n i f m a v i   w i t h   ( n o l o c k ) 
 w h e r e   m o v   =   @ m o v p a d r e 
 a n d   u e n   =   @ u e n 
 i f   @ m o v c r e a r   i s   n u l l 
 s e l e c t 
 @ m o v c r e a r   =   ' n o t a   c r e d i t o ' 
 s e l e c t 
 @ c o n c e p t o   =   c o n c e p t o 
 f r o m   m a v i b o n i f i c a c i o n c o n f   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d p o l 
 i n s e r t   i n t o   c x c   ( e m p r e s a ,   m o v ,   m o v i d ,   f e c h a e m i s i o n ,   u l t i m o c a m b i o ,   c o n c e p t o ,   p r o y e c t o ,   m o n e d a ,   t i p o c a m b i o ,   u s u a r i o ,   a u t o r i z a c i o n ,   r e f e r e n c i a ,   d o c f u e n t e , 
 o b s e r v a c i o n e s ,   e s t a t u s ,   s i t u a c i o n ,   s i t u a c i o n f e c h a ,   s i t u a c i o n u s u a r i o ,   s i t u a c i o n n o t a ,   c l i e n t e ,   c l i e n t e e n v i a r a ,   c l i e n t e m o n e d a ,   c l i e n t e t i p o c a m b i o , 
 c o b r a d o r ,   c o n d i c i o n ,   v e n c i m i e n t o ,   f o r m a c o b r o ,   c t a d i n e r o ,   i m p o r t e ,   i m p u e s t o s ,   r e t e n c i o n ,   a p l i c a m a n u a l ,   c o n d e s g l o s e ,   f o r m a c o b r o 1 ,   f o r m a c o b r o 2 , 
 f o r m a c o b r o 3 ,   f o r m a c o b r o 4 ,   f o r m a c o b r o 5 ,   r e f e r e n c i a 1 ,   r e f e r e n c i a 2 ,   r e f e r e n c i a 3 ,   r e f e r e n c i a 4 ,   r e f e r e n c i a 5 ,   i m p o r t e 1 ,   i m p o r t e 2 ,   i m p o r t e 3 , 
 i m p o r t e 4 ,   i m p o r t e 5 ,   c a m b i o ,   d e l e f e c t i v o ,   a g e n t e ,   c o m i s i o n t o t a l ,   c o m i s i o n p e n d i e n t e ,   m o v a p l i c a ,   m o v a p l i c a i d ,   o r i g e n t i p o ,   o r i g e n ,   o r i g e n i d , 
 p o l i z a ,   p o l i z a i d ,   f e c h a c o n c l u s i o n ,   f e c h a c a n c e l a c i o n ,   d i n e r o ,   d i n e r o i d ,   d i n e r o c t a d i n e r o ,   c o n t r a m i t e s ,   v i n ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   c a j e r o , 
 u e n ,   p e r s o n a l c o b r a d o r ,   f e c h a o r i g i n a l ,   n o t a ,   c o m e n t a r i o s ,   l i n e a c r e d i t o ,   t i p o a m o r t i z a c i o n ,   t i p o t a s a ,   a m o r t i z a c i o n e s ,   c o m i s i o n e s ,   c o m i s i o n e s i v a , 
 f e c h a r e v i s i o n ,   c o n t u s o ,   t i e n e t a s a e s p ,   t a s a e s p ,   c o d i ) 
 v a l u e s   ( @ e m p r e s a ,   @ m o v c r e a r ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   @ f e c h a a p l i c a c i o n ,   @ c o n c e p t o ,   n u l l ,   @ m o n e d a ,   @ t i p o c a m b i o ,   @ u s u a r i o ,   n u l l ,   @ r e f e r e n c i a ,   n u l l , 
 n u l l ,   ' s i n a f e c t a r ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   @ c o n t a c t o ,   @ c a n a l v e n t a ,   @ m o n e d a ,   @ t i p o c a m b i o , 
 n u l l ,   n u l l ,   c a s t ( c o n v e r t ( v a r c h a r ,   @ f e c h a a p l i c a c i o n ,   1 0 1 )   a s   d a t e t i m e ) ,   n u l l ,   @ c t a d i n e r o ,   n u l l ,   n u l l ,   n u l l ,   1 ,   0 ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l , 
 n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   @ u e n ,   n u l l ,   n u l l ,   n u l l ,   ' ' ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   0 ,   n u l l ,   n u l l ) 
 s e l e c t 
 @ i d c x c   =   @ @ i d e n t i t y 
 u p d a t e   n e c i a m o r a t o r i o s m a v i   w i t h   ( r o w l o c k ) 
 s e t   n o t a c r e d b o n i d   =   @ i d c x c 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   o r i g e n   =   @ o r i g e n 
 a n d   o r i g e n i d   =   @ o r i g e n i d 
 a n d   i d p a p u n t u a l   =   @ i d p o l 
 a n d   n o t a c r e d i t o x c a n c   i s   n u l l 
 i n s e r t   i n t o   # c r d e t n c b o n i f p p 2   ( m o v ,   m o v i d ,   p a p u n t u a l ) 
 s e l e c t 
 m o v , 
 m o v i d , 
 c a s e 
 w h e n   p a p u n t u a l   >   b o n i f i c a c i o n   t h e n   b o n i f i c a c i o n 
 e l s e   p a p u n t u a l 
 e n d 
 f r o m   n e c i a m o r a t o r i o s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   i d c o b r o   =   @ i d 
 a n d   p a p u n t u a l   >   0 
 a n d   n o t a c r e d i t o x c a n c   i s   n u l l 
 a n d   o r i g e n   =   @ o r i g e n 
 a n d   o r i g e n i d   =   @ o r i g e n i d 
 s e l e c t 
 @ m i n d e t 2   =   m i n ( i d ) , 
 @ m a x d e t 2   =   m a x ( i d ) 
 f r o m   # c r d e t n c b o n i f p p 2 
 w h i l e   @ m i n d e t 2   < =   @ m a x d e t 2 
 b e g i n 
 s e l e c t 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ i m p d o c t o   =   p a p u n t u a l 
 f r o m   # c r d e t n c b o n i f p p 2 
 w h e r e   i d   =   @ m i n d e t 2 
 i n s e r t   i n t o   c x c d   ( i d ,   r e n g l o n ,   r e n g l o n s u b ,   a p l i c a ,   a p l i c a i d ,   i m p o r t e ,   f e c h a ,   s u c u r s a l ,   s u c u r s a l o r i g e n ,   d e s c u e n t o r e c a r s ,   i n t e r e s e s o r d i n a r i o s , 
 i n t e r e s e s m o r a t o r i o s ,   i n t e r e s e s o r d i n a r i o s q u i t a ,   i n t e r e s e s m o r a t o r i o s q u i t a ,   i m p u e s t o a d i c i o n a l ,   r e t e n c i o n ) 
 v a l u e s   ( @ i d c x c ,   @ r e n g l o n ,   0 ,   @ m o v ,   @ m o v i d ,   @ i m p d o c t o ,   n u l l ,   @ s u c u r s a l ,   @ s u c u r s a l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ,   n u l l ) 
 s e t   @ r e n g l o n   =   @ r e n g l o n   +   1 0 2 4 . 0 
 s e t   @ m i n d e t 2   =   @ m i n d e t 2   +   1 
 e n d 
 s e l e c t 
 @ i m p u e s t o s   =   s u m ( d . i m p o r t e   *   i s n u l l ( c a . i v a f i s c a l ,   0 . 0 0 ) ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c a p l i c a   c a   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c a . m o v 
 a n d   d . a p l i c a i d   =   c a . m o v i d 
 a n d   c a . e m p r e s a   =   @ e m p r e s a 
 w h e r e   d . i d   =   @ i d c x c 
 s e l e c t 
 @ t o t a l m o v   =   s u m ( d . i m p o r t e   -   i s n u l l ( d . i m p o r t e   *   c a . i v a f i s c a l ,   0 ) ) 
 f r o m   c x c d   d   w i t h   ( n o l o c k ) 
 j o i n   c x c a p l i c a   c a   w i t h   ( n o l o c k ) 
 o n   d . a p l i c a   =   c a . m o v 
 a n d   d . a p l i c a i d   =   c a . m o v i d 
 a n d   c a . e m p r e s a   =   @ e m p r e s a 
 w h e r e   d . i d   =   @ i d c x c 
 u p d a t e   c x c   w i t h   ( r o w l o c k ) 
 s e t   i m p o r t e   =   i s n u l l ( r o u n d ( @ t o t a l m o v ,   2 ) ,   0 . 0 0 ) , 
 i m p u e s t o s   =   i s n u l l ( r o u n d ( @ i m p u e s t o s ,   2 ) ,   0 . 0 0 ) , 
 s a l d o   =   i s n u l l ( r o u n d ( @ t o t a l m o v ,   2 ) ,   0 . 0 0 )   +   i s n u l l ( r o u n d ( @ i m p u e s t o s ,   2 ) ,   0 . 0 0 ) , 
 i d c o b r o b o n i f m a v i   =   @ i d 
 w h e r e   i d   =   @ i d c x c 
 e x e c   s p a f e c t a r   ' c x c ' , 
 @ i d c x c , 
 ' a f e c t a r ' , 
 ' t o d o ' , 
 n u l l , 
 @ u s u a r i o , 
 n u l l , 
 1 , 
 @ o k   o u t p u t , 
 @ o k r e f   o u t p u t , 
 n u l l , 
 @ c o n e x i o n   =   1 
 i n s e r t   i n t o   d e t a l l e a f e c t a c i o n m a v i   ( i d c o b r o ,   i d ,   m o v ,   m o v i d ,   v a l o r o k ,   v a l o r o k r e f ) 
 v a l u e s   ( @ i d ,   @ i d c x c ,   @ m o v c r e a r ,   n u l l ,   @ o k ,   @ o k r e f ) 
 s e t   @ m i n b o n 2   =   @ m i n b o n 2   +   1 
 e n d 
 e n d 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r g e n b o n i f p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r g e n b o n i f p 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r d e t n c b o n i f p p ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r d e t n c b o n i f p p 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r g e n b o n i f p p 2 ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r g e n b o n i f p p 2 
 i f   e x i s t s   ( s e l e c t 
 i d 
 f r o m   t e m p d b . s y s . s y s o b j e c t s 
 w h e r e   i d   =   o b j e c t _ i d ( ' t e m p d b . d b o . # c r d e t n c b o n i f p p 2 ' ) 
 a n d   t y p e   =   ' u ' ) 
 d r o p   t a b l e   # c r d e t n c b o n i f p p 2 
 e n d 
 r e t u r n 