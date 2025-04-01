// pages/MainPage/MainPage.js
Page({

    /**
     * 页面的初始数据
     */
    data: {
      // 访客信息
      visitorInfo: {
        name: "",
        phone: "",
        avatarUrl: "/images/default-avatar.png"
      },
      // 咨询记录数据
      scrollItems: [],
      // 页面高度
      pageHeight: 0
    },

    /**
     * 生命周期函数--监听页面加载
     */
    onLoad(options) {
      // 获取系统信息设置页面高度
      const systemInfo = wx.getSystemInfoSync();
      this.setData({
        pageHeight: systemInfo.windowHeight
      });
      
      // 获取访客信息和咨询记录
      this.fetchVisitorInfo();
      this.fetchConsultationHistory();
    },

    /**
     * 生命周期函数--监听页面初次渲染完成
     */
    onReady() {

    },

    /**
     * 生命周期函数--监听页面显示
     */
    onShow() {

    },

    /**
     * 生命周期函数--监听页面隐藏
     */
    onHide() {

    },

    /**
     * 生命周期函数--监听页面卸载
     */
    onUnload() {
    },

    /**
     * 页面相关事件处理函数--监听用户下拉动作
     */
    onPullDownRefresh() {
      // 下拉刷新
      this.fetchVisitorInfo();
      this.fetchConsultationHistory();
    },

    /**
     * 页面上拉触底事件的处理函数
     */
    onReachBottom() {

    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage() {

    },

    // 获取访客信息
    fetchVisitorInfo() {
      // 从本地存储获取访客信息
      const visitorInfo = wx.getStorageSync('visitorInfo');
      if (visitorInfo) {
        this.setData({
          visitorInfo: {
            ...this.data.visitorInfo,
            ...visitorInfo
          }
        });
      }
    },

    // 获取咨询记录
    fetchConsultationHistory() {
      // 模拟API调用
      const mockData = [
        {
          id: 1,
          time: '2024-03-26 14:30',
          image: '/images/chat-icon.png',
          description: '心理咨询记录1'
        },
        {
          id: 2,
          time: '2024-03-25 15:45',
          image: '/images/chat-icon.png',
          description: '心理咨询记录2'
        }
      ];

      this.setData({
        scrollItems: mockData
      });

      // 完成下拉刷新
      wx.stopPullDownRefresh();
    },

    // 处理在线咨询
    handleConsult() {
      wx.navigateTo({
        url: '/pages/Chatpage/Chatpage'
      });
    },

    // 导航到聊天页面
    navigateToChat(e) {
      const id = e.currentTarget.dataset.id;
      wx.navigateTo({
        url: `/pages/Chatpage/Chatpage?id=${id}`
      });
    },

    // 处理退出登录
    handleLogout() {
      wx.showModal({
        title: '确认退出',
        content: '确定要退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            // 清除本地存储的用户信息
            wx.removeStorageSync('userInfo');
            wx.removeStorageSync('visitorInfo');
            
            // 跳转到登录页面
            wx.reLaunch({
              url: '/pages/FirstPage/FirstPage'
            });
          }
        }
      });
    }
})