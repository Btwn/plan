u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p v e n t a c t e d a c e p t a r ]   @ s u c u r s a l   i n t , 
 @ e s t a c i o n   i n t , 
 @ v e n t a i d   i n t , 
 @ m o v t i p o   c h a r ( 2 0 ) , 
 @ c o p i a r a p l i c a c i o n   b i t   =   0 , 
 @ c o p i a r i d v e n t a   i n t   =   0 
 a s 
 b e g i n 
 d e c l a r e   @ e m p r e s a   c h a r ( 5 ) , 
 @ i d   i n t , 
 @ m o v   c h a r ( 2 0 ) , 
 @ m o v i d   v a r c h a r ( 2 0 ) , 
 @ m o v r e f e r e n c i a   v a r c h a r ( 5 0 ) , 
 @ t i e n e a l   b i t , 
 @ d i r e c t o   b i t , 
 @ c l i e n t e   c h a r ( 1 0 ) , 
 @ r e n g l o n   f l o a t , 
 @ r e n g l o n i d   i n t , 
 @ v e n t a d r e n g l o n   f l o a t , 
 @ v e n t a d r e n g l o n i d   i n t , 
 @ v e n t a d r e n g l o n s u b   i n t , 
 @ r e n g l o n t i p o   c h a r ( 1 ) , 
 @ z o n a i m p u e s t o   v a r c h a r ( 3 0 ) , 
 @ c a n t i d a d   f l o a t , 
 @ c a n t i d a d i n v e n t a r i o   f l o a t , 
 @ a l m a c e n   c h a r ( 1 0 ) , 
 @ c o d i   v a r c h a r ( 5 0 ) , 
 @ a r t i c u l o   c h a r ( 2 0 ) , 
 @ s u b c u e n t a   v a r c h a r ( 5 0 ) , 
 @ u n i d a d   v a r c h a r ( 5 0 ) , 
 @ p r e c i o   m o n e y , 
 @ d e s c u e n t o t i p o   c h a r ( 1 ) , 
 @ d e s c u e n t o l i n e a   m o n e y , 
 @ i m p u e s t o 1   f l o a t , 
 @ i m p u e s t o 2   f l o a t , 
 @ i m p u e s t o 3   m o n e y , 
 @ d e s c r i p c i o n e x t r a   v a r c h a r ( 1 0 0 ) , 
 @ c o s t o   m o n e y , 
 @ c o n t u s o   v a r c h a r ( 2 0 ) , 
 @ a p l i c a   c h a r ( 2 0 ) , 
 @ a p l i c a i d   c h a r ( 2 0 ) , 
 @ a g e n t e   c h a r ( 1 0 ) , 
 @ a g e n t e d   c h a r ( 1 0 ) , 
 @ d e s c u e n t o   v a r c h a r ( 3 0 ) , 
 @ d e s c u e n t o g l o b a l   f l o a t , 
 @ f o r m a p a t i p o   v a r c h a r ( 5 0 ) , 
 @ s o b r e p r e c i o   f l o a t , 
 @ a r t t i p o   v a r c h a r ( 2 0 ) , 
 @ d e p a r t a m e n t o   i n t , 
 @ d e p a r t a m e n t o d   i n t , 
 @ d e s c u e n t o i m p o r t e   m o n e y , 
 @ c f g s e r i e s l o t e s a u t o o r d e n   c h a r ( 2 0 ) , 
 @ f i n a n c i a m i e n t o   f l o a t , 
 @ i m p o r t e v d   m o n e y , 
 @ p u n t o s   m o n e y 
 s e l e c t 
 @ t i e n e a l   =   0 , 
 @ r e n g l o n i d   =   0 
 s e l e c t 
 @ r e n g l o n   =   i s n u l l ( m a x ( r e n g l o n ) ,   0 ) 
 f r o m   v e n t a d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ v e n t a i d 
 s e l e c t 
 @ e m p r e s a   =   e m p r e s a , 
 @ c l i e n t e   =   c l i e n t e , 
 @ d i r e c t o   =   d i r e c t o , 
 @ r e n g l o n i d   =   i s n u l l ( r e n g l o n i d ,   0 ) 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ v e n t a i d 
 s e l e c t 
 @ z o n a i m p u e s t o   =   z o n a i m p u e s t o 
 f r o m   c t e   w i t h   ( n o l o c k ) 
 w h e r e   c l i e n t e   =   @ c l i e n t e 
 s e l e c t 
 @ c f g s e r i e s l o t e s a u t o o r d e n   =   i s n u l l ( u p p e r ( r t r i m ( s e r i e s l o t e s a u t o o r d e n ) ) ,   ' n o ' ) 
 f r o m   e m p r e s a c f g   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 b e g i n   t r a n s a c t i o n 
 d e c l a r e   c r v e n t a c t e d   c u r s o r   f o r 
 s e l e c t 
 d . f i n a n c i a m i e n t o , 
 l . i d , 
 l . c a n t i d a d a , 
 ( l . c a n t i d a d a   *   d . c a n t i d a d i n v e n t a r i o   /   i s n u l l ( n u l l i f ( d . c a n t i d a d ,   0 . 0 ) ,   1 . 0 ) ) , 
 d . r e n g l o n , 
 d . r e n g l o n s u b , 
 d . r e n g l o n i d , 
 r e n g l o n t i p o , 
 a l m a c e n , 
 c o d i , 
 a r t i c u l o , 
 s u b c u e n t a , 
 u n i d a d , 
 p r e c i o , 
 d e s c u e n t o t i p o , 
 d e s c u e n t o l i n e a , 
 d e s c u e n t o i m p o r t e , 
 i m p u e s t o 1 , 
 i m p u e s t o 2 , 
 i m p u e s t o 3 , 
 c o s t o , 
 c o n t u s o , 
 a p l i c a , 
 a p l i c a i d , 
 a g e n t e , 
 d e p a r t a m e n t o , 
 d . p u n t o s 
 f r o m   v e n t a d   d   w i t h   ( n o l o c k ) , 
 v e n t a c t e d l i s t a   l   w i t h   ( n o l o c k ) 
 w h e r e   l . e s t a c i o n   =   @ e s t a c i o n 
 a n d   i s n u l l ( l . c a n t i d a d a ,   0 . 0 )   >   0 
 a n d   d . i d   =   l . i d 
 a n d   d . r e n g l o n   =   l . r e n g l o n 
 a n d   d . r e n g l o n s u b   =   l . r e n g l o n s u b 
 o r d e r   b y   l . i d ,   l . r e n g l o n ,   l . r e n g l o n s u b 
 o p e n   c r v e n t a c t e d 
 f e t c h   n e x t   f r o m   c r v e n t a c t e d   i n t o   @ f i n a n c i a m i e n t o ,   @ i d ,   @ c a n t i d a d ,   @ c a n t i d a d i n v e n t a r i o ,   @ v e n t a d r e n g l o n ,   @ v e n t a d r e n g l o n s u b ,   @ v e n t a d r e n g l o n i d ,   @ r e n g l o n t i p o ,   @ a l m a c e n , 
 @ c o d i ,   @ a r t i c u l o ,   @ s u b c u e n t a ,   @ u n i d a d ,   @ p r e c i o ,   @ d e s c u e n t o t i p o ,   @ d e s c u e n t o l i n e a ,   @ d e s c u e n t o i m p o r t e ,   @ i m p u e s t o 1 ,   @ i m p u e s t o 2 , 
 @ i m p u e s t o 3 ,   @ c o s t o ,   @ c o n t u s o ,   @ a p l i c a ,   @ a p l i c a i d ,   @ a g e n t e d ,   @ d e p a r t a m e n t o d ,   @ p u n t o s 
 w h i l e   @ @ f e t c h _ s t a t u s   < >   - 1 
 b e g i n 
 i f   @ @ f e t c h _ s t a t u s   < >   - 2 
 b e g i n 
 i f   @ t i e n e a l   =   0 
 b e g i n 
 s e l e c t 
 @ t i e n e a l   =   1 
 s e l e c t 
 @ e m p r e s a   =   e m p r e s a , 
 @ m o v   =   m o v , 
 @ m o v i d   =   m o v i d , 
 @ m o v r e f e r e n c i a   =   n u l l i f ( r t r i m ( r e f e r e n c i a ) ,   ' ' ) , 
 @ a g e n t e   =   a g e n t e , 
 @ d e s c u e n t o   =   d e s c u e n t o , 
 @ d e s c u e n t o g l o b a l   =   d e s c u e n t o g l o b a l , 
 @ f o r m a p a t i p o   =   f o r m a p a t i p o , 
 @ s o b r e p r e c i o   =   s o b r e p r e c i o , 
 @ d e p a r t a m e n t o   =   d e p a r t a m e n t o 
 f r o m   v e n t a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   p o l i t i c a s m o n e d e r o a p l i c a d a s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ v e n t a i d ) 
 d e l e t e   f r o m   p o l i t i c a s m o n e d e r o a p l i c a d a s m a v i 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ v e n t a i d 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   v e n t a c t e d l i s t a   v l   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ i d 
 a n d   i s n u l l ( v l . c a n t i d a d a ,   0 . 0 )   >   0 ) 
 i n s e r t   p o l i t i c a s m o n e d e r o a p l i c a d a s m a v i   ( e m p r e s a ,   m o d u l o ,   i d ,   r e n g l o n ,   a r t i c u l o ,   i d p o l i t i c a ) 
 s e l e c t 
 v . e m p r e s a , 
 ' v t a s ' , 
 @ v e n t a i d , 
 d . r e n g l o n , 
 d . a r t i c u l o , 
 ( d . p u n t o s   /   d . c a n t i d a d )   *   i s n u l l ( v l . c a n t i d a d a ,   0 . 0 ) 
 f r o m   v e n t a   v   w i t h   ( n o l o c k ) 
 j o i n   v e n t a d   d   w i t h   ( n o l o c k ) 
 o n   v . i d   =   d . i d 
 j o i n   v e n t a c t e d l i s t a   v l   w i t h   ( n o l o c k ) 
 o n   d . r e n g l o n   =   v l . r e n g l o n 
 a n d   i s n u l l ( v l . c a n t i d a d a ,   0 . 0 )   >   0 
 a n d   v l . i d   =   @ i d 
 w h e r e   v . i d   =   @ i d 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   t a r j e t a s e r i e m o v m a v i   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ v e n t a i d ) 
 d e l e t e   f r o m   t a r j e t a s e r i e m o v m a v i 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ v e n t a i d 
 i f   e x i s t s   ( s e l e c t 
 * 
 f r o m   t a r j e t a s e r i e m o v m a v i   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ i d ) 
 i n s e r t   t a r j e t a s e r i e m o v m a v i   ( e m p r e s a ,   m o d u l o ,   i d ,   s e r i e ,   i m p o r t e ,   s u c u r s a l ) 
 s e l e c t 
 e m p r e s a , 
 m o d u l o , 
 @ v e n t a i d , 
 s e r i e , 
 i m p o r t e , 
 s u c u r s a l 
 f r o m   t a r j e t a s e r i e m o v m a v i   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ i d 
 e n d 
 s e l e c t 
 @ p u n t o s   =   i d p o l i t i c a 
 f r o m   p o l i t i c a s m o n e d e r o a p l i c a d a s m a v i   w i t h   ( n o l o c k ) 
 w h e r e   e m p r e s a   =   @ e m p r e s a 
 a n d   m o d u l o   =   ' v t a s ' 
 a n d   i d   =   @ v e n t a i d 
 a n d   r e n g l o n   =   @ v e n t a d r e n g l o n 
 e x e c   s p z o n a i m p   @ z o n a i m p u e s t o , 
 @ i m p u e s t o 1   o u t p u t 
 e x e c   s p z o n a i m p   @ z o n a i m p u e s t o , 
 @ i m p u e s t o 2   o u t p u t 
 s e l e c t 
 @ r e n g l o n   =   @ r e n g l o n   +   2 0 4 8 , 
 @ r e n g l o n i d   =   @ r e n g l o n i d   +   1 
 i f   @ m o v t i p o   n o t   i n   ( ' v t a s . d ' ,   ' v t a s . d f ' ,   ' v t a s . s d ' ,   ' v t a s . d f c ' ) 
 s e l e c t 
 @ c o s t o   =   n u l l 
 i f   @ c o p i a r a p l i c a c i o n   =   0 
 s e l e c t 
 @ a p l i c a   =   n u l l , 
 @ a p l i c a i d   =   n u l l 
 i f   @ a p l i c a   i s   n o t   n u l l 
 s e l e c t 
 @ d i r e c t o   =   0 
 i f   ( @ c o p i a r i d v e n t a   =   1 ) 
 b e g i n 
 i f   n o t   e x i s t s   ( s e l e c t 
 * 
 f r o m   v e n t a d   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ v e n t a i d 
 a n d   a r t i c u l o   =   @ a r t i c u l o ) 
 b e g i n 
 i n s e r t   v e n t a d   ( f i n a n c i a m i e n t o ,   i d c o p i a m a v i ,   s u c u r s a l ,   i d ,   r e n g l o n ,   r e n g l o n s u b ,   r e n g l o n i d ,   r e n g l o n t i p o ,   a l m a c e n ,   c o d i ,   a r t i c u l o ,   s u b c u e n t a ,   u n i d a d ,   c a n t i d a d ,   c a n t i d a d i n v e n t a r i o ,   p r e c i o ,   d e s c u e n t o t i p o ,   d e s c u e n t o l i n e a ,   d e s c u e n t o i m p o r t e , 
 i m p u e s t o 1 ,   i m p u e s t o 2 ,   i m p u e s t o 3 ,   c o s t o ,   c o n t u s o ,   a p l i c a ,   a p l i c a i d ,   a g e n t e ,   d e p a r t a m e n t o ,   p u n t o s ) 
 v a l u e s   ( @ f i n a n c i a m i e n t o ,   @ i d ,   @ s u c u r s a l ,   @ v e n t a i d ,   @ r e n g l o n ,   0 ,   @ r e n g l o n i d ,   @ r e n g l o n t i p o ,   @ a l m a c e n ,   @ c o d i ,   @ a r t i c u l o ,   @ s u b c u e n t a ,   @ u n i d a d ,   @ c a n t i d a d ,   @ c a n t i d a d i n v e n t a r i o ,   @ p r e c i o ,   @ d e s c u e n t o t i p o ,   @ d e s c u e n t o l i n e a ,   @ d e s c u e n t o i m p o r t e ,   @ i m p u e s t o 1 ,   @ i m p u e s t o 2 ,   @ i m p u e s t o 3 ,   @ c o s t o ,   @ c o n t u s o ,   @ a p l i c a ,   @ a p l i c a i d ,   @ a g e n t e d ,   @ d e p a r t a m e n t o d ,   @ p u n t o s ) 
 e n d 
 e l s e 
 b e g i n 
 u p d a t e   v e n t a d   w i t h   ( r o w l o c k ) 
 s e t   p u n t o s   =   @ p u n t o s 
 w h e r e   a r t i c u l o   =   @ a r t i c u l o   a n d   i d = @ v e n t a i d 
 e n d 
 e n d 
 e l s e 
 b e g i n 
 i n s e r t   v e n t a d   ( f i n a n c i a m i e n t o ,   i d c o p i a m a v i ,   s u c u r s a l ,   i d ,   r e n g l o n ,   r e n g l o n s u b ,   r e n g l o n i d ,   r e n g l o n t i p o ,   a l m a c e n ,   c o d i ,   a r t i c u l o ,   s u b c u e n t a ,   u n i d a d ,   c a n t i d a d ,   c a n t i d a d i n v e n t a r i o ,   p r e c i o ,   d e s c u e n t o t i p o ,   d e s c u e n t o l i n e a ,   d e s c u e n t o i m p o r t e , 
 i m p u e s t o 1 ,   i m p u e s t o 2 ,   i m p u e s t o 3 ,   c o s t o ,   c o n t u s o ,   a p l i c a ,   a p l i c a i d ,   a g e n t e ,   d e p a r t a m e n t o ,   p u n t o s ) 
 v a l u e s   ( @ f i n a n c i a m i e n t o ,   @ i d ,   @ s u c u r s a l ,   @ v e n t a i d ,   @ r e n g l o n ,   0 ,   @ r e n g l o n i d ,   @ r e n g l o n t i p o ,   @ a l m a c e n ,   @ c o d i ,   @ a r t i c u l o ,   @ s u b c u e n t a ,   @ u n i d a d ,   @ c a n t i d a d ,   @ c a n t i d a d i n v e n t a r i o ,   @ p r e c i o ,   @ d e s c u e n t o t i p o ,   @ d e s c u e n t o l i n e a ,   @ d e s c u e n t o i m p o r t e ,   @ i m p u e s t o 1 ,   @ i m p u e s t o 2 ,   @ i m p u e s t o 3 ,   @ c o s t o ,   @ c o n t u s o ,   @ a p l i c a ,   @ a p l i c a i d ,   @ a g e n t e d ,   @ d e p a r t a m e n t o d ,   @ p u n t o s ) 
 e n d 
 e x e c   s p a r t t i p o   @ r e n g l o n t i p o , 
 @ a r t t i p o   o u t p u t 
 i f   @ a r t t i p o   i n   ( ' s e r i e ' ,   ' l o t e ' ,   ' v i n ' ,   ' p a r t i d a ' ) 
 e x e c   s p v e n t a c t e d s e r i e l o t e   @ e m p r e s a , 
 @ s u c u r s a l , 
 @ c f g s e r i e s l o t e s a u t o o r d e n , 
 @ i d , 
 @ v e n t a d r e n g l o n i d , 
 @ r e n g l o n i d , 
 @ v e n t a i d , 
 @ a r t i c u l o , 
 @ s u b c u e n t a , 
 @ c a n t i d a d 
 i f   ( @ c o p i a r i d v e n t a   =   0 ) 
 b e g i n 
 i f   @ a r t t i p o   =   ' j u e ' 
 e x e c   s p v e n t a c t e d c o m p o n e n t e s   @ s u c u r s a l , 
 @ i d , 
 @ v e n t a d r e n g l o n , 
 @ v e n t a d r e n g l o n s u b , 
 @ c a n t i d a d , 
 @ m o v t i p o , 
 @ v e n t a i d , 
 @ a l m a c e n , 
 @ r e n g l o n , 
 @ r e n g l o n i d , 
 @ c o p i a r a p l i c a c i o n , 
 @ e m p r e s a , 
 @ c f g s e r i e s l o t e s a u t o o r d e n 
 e n d 
 e n d 
 f e t c h   n e x t   f r o m   c r v e n t a c t e d   i n t o   @ f i n a n c i a m i e n t o ,   @ i d ,   @ c a n t i d a d ,   @ c a n t i d a d i n v e n t a r i o ,   @ v e n t a d r e n g l o n ,   @ v e n t a d r e n g l o n s u b ,   @ v e n t a d r e n g l o n i d ,   @ r e n g l o n t i p o ,   @ a l m a c e n ,   @ c o d i ,   @ a r t i c u l o ,   @ s u b c u e n t a ,   @ u n i d a d ,   @ p r e c i o ,   @ d e s c u e n t o t i p o ,   @ d e s c u e n t o l i n e a ,   @ d e s c u e n t o i m p o r t e ,   @ i m p u e s t o 1 ,   @ i m p u e s t o 2 ,   @ i m p u e s t o 3 ,   @ c o s t o ,   @ c o n t u s o ,   @ a p l i c a ,   @ a p l i c a i d ,   @ a g e n t e d ,   @ d e p a r t a m e n t o d ,   @ p u n t o s 
 e n d 
 c l o s e   c r v e n t a c t e d 
 d e a l l o c a t e   c r v e n t a c t e d 
 i f   @ t i e n e a l   =   1 
 b e g i n 
 i f   @ m o v r e f e r e n c i a   i s   n u l l 
 s e l e c t 
 @ m o v r e f e r e n c i a   =   r t r i m ( @ m o v )   +   '   '   +   r t r i m ( @ m o v i d ) 
 u p d a t e   v e n t a   w i t h   ( r o w l o c k ) 
 s e t   r e f e r e n c i a   =   @ m o v r e f e r e n c i a , 
 d i r e c t o   =   @ d i r e c t o , 
 a g e n t e   =   @ a g e n t e , 
 d e s c u e n t o   =   @ d e s c u e n t o , 
 d e s c u e n t o g l o b a l   =   @ d e s c u e n t o g l o b a l , 
 f o r m a p a t i p o   =   @ f o r m a p a t i p o , 
 s o b r e p r e c i o   =   @ s o b r e p r e c i o , 
 r e n g l o n i d   =   @ r e n g l o n i d , 
 d e p a r t a m e n t o   =   @ d e p a r t a m e n t o 
 w h e r e   i d   =   @ v e n t a i d 
 e n d 
 d e l e t e   v e n t a c t e d l i s t a 
 w h e r e   e s t a c i o n   =   @ e s t a c i o n 
 c o m m i t   t r a n s a c t i o n 
 e n d 