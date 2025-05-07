Page({
    data: {
      canAgree: false,
      remainingTime: 3,
    },
    onShow() {
      // 在页面显示时立即隐藏 TabBar
    },
  
    onLoad() {
      // 开始倒计时
      this.startCountdown();
    },
  
    onUnload() {
      // 页面卸载时显示 TabBar
      wx.showTabBar({
        animation: false
      });
    },
  
    startCountdown() {
      let timeLeft = 3;
      const timer = setInterval(() => {
        timeLeft--;
        this.setData({
          remainingTime: timeLeft
        });
  
        if (timeLeft <= 0) {
          clearInterval(timer);
          this.setData({
            canAgree: true
          });
        }
      }, 1000);
    },
  
    handleAgree() {
      if (!this.data.canAgree) return;
  
      // 跳转到聊天页面
      wx.navigateTo({
        url: '/pages/Chat2/Chat2'
      });
    },
    onBack() {
        // 自定义返回逻辑
        wx.navigateBack({
          delta: 1, // 返回前2个页面（可调整）
          success() {
            console.log("返回成功");
          },
          fail(err) {
            console.error("返回失败", err);
          }
        });
      }
  });