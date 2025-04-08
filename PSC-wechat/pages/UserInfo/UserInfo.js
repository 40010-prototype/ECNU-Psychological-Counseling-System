Page({
  data: {
    userInfo: {
      avatar: '',
      name: '',
      phone: '',
      email: ''
    }
  },

  onLoad: function() {
    this.fetchUserInfo();
  },

  onShow: function() {
    // 每次页面显示时重新获取用户信息
    this.fetchUserInfo();
  },

  // 获取用户信息
  fetchUserInfo: function() {
    // 从本地存储获取用户信息
    const userInfo = wx.getStorageSync('userInfo');
    if (userInfo) {
      this.setData({
        userInfo: userInfo
      });
    }
  },

  // 处理修改信息按钮点击
  handleEdit: function() {
    wx.navigateTo({
      url: '/pages/AddUserInfo/AddUserInfo'
    });
  },

  // 处理退出登录
  handleLogout: function() {
    wx.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: (res) => {
        if (res.confirm) {
          // 清除本地存储的用户信息
          wx.removeStorageSync('userInfo');
          wx.removeStorageSync('token');
          
          // 跳转到登录页
          wx.reLaunch({
            url: '/pages/FirstPage/FirstPage'
          });
        }
      }
    });
  }
}); 