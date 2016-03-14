## SSDragCard
卡片拖动 以及 菜单类 代码展示
## 效果展示稍后上传
（gif录制的真是low到爆了，难道是我选的背景色不对？）  
卡片  
![卡片](https://github.com/xfdev/SSDragCard/blob/master/readmeGif/card.gif)

菜单  
![菜单](https://github.com/xfdev/SSDragCard/blob/master/readmeGif/menu.gif)

## 一些介绍
`SSMenuViewController`主页面，包括卡片（`SSCardView`）拖动和动画菜单（`SSMenuView`）两大模块:  
（底部呼吸效果代码也在这个类中）

### SSCardView 卡片
屏幕中间为`SSCardView`卡片，在此项目中这个View卡片一共创建4次（界面一次显示的总卡片数），然后在每次把最顶端卡片移除屏幕后，并没有销毁这个View，而是把它挪动到最底下的一张，这时候其他卡片依次往前排列（可查看卡片移除屏幕时的block回调`SSCardViewBlock`），最终结果就是这四张卡片来回调用，改变的只是卡片上的image内容；

#### SSMenuView 菜单
菜单动画主要使用`CAKeyframeAnimation`动画，`keyPath`设置为`transform.scale`，然后就是子菜单大小数组值`values`，`values`是一个数组类型，就是从数组中第0个开始执行一直执行到数组中最后一个，然后是时间循环次数等代码；排列方式也可在该view中自定义修改。`SSMenuViewBlock`为点击子菜单中的索引回调，自己去实现相关触发方法。  

最后，欢迎一起学习交流！（如何找我，你懂得。。。）