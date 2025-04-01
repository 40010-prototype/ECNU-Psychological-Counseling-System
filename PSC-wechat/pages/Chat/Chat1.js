Page({
    data: {
      canAgree: false,
      remainingTime: 10,
    },
  
    onLoad() {
      wx.hideTabBar(); // 隐藏 tabBar
      this.startCountdown();
    },
  
    onUnload() {
      wx.showTabBar(); // 显示 tabBar
    },
  
    startCountdown() {
      let countdown = setInterval(() => {
        const remainingTime = this.data.remainingTime - 1;
        if (remainingTime <= 0) {
          clearInterval(countdown);
          this.setData({
            canAgree: true,
            remainingTime: 0,
          });
        } else {
          this.setData({
            remainingTime,
          });
        }
      }, 1000);
    },
  
    handleAgree() {
      if (this.data.canAgree) {
        wx.navigateTo({
          url: '/pages/Chat2/Chat2',
        });
      }
    },
  });