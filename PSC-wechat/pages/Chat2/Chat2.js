const app = getApp()
Page({
  data: {
    counselors: [],
    loading: true,
    error: null,
    refreshing: false
  },

  onLoad: function() {
    this.loadLocalCounselors();
  },

  // 从本地存储加载咨询师数据
  loadLocalCounselors: function() {
    try {
      const localCounselors = wx.getStorageSync('counselors');
      if (localCounselors && Array.isArray(localCounselors)) {
        this.setData({
          counselors: localCounselors.map(item => ({
            id: item.id || '',
            name: item.name || '未知咨询师',
            phone: item.phone || '',
            // 其他需要展示的字段...
          })),
          loading: false
        });
      }
    } catch (e) {
      console.error('读取本地咨询师数据失败:', e);
    }
    // 仍然从服务器获取最新数据
    this.fetchCounselors();
  },

  fetchCounselors: function() {
    this.setData({ 
      loading: this.data.counselors.length === 0,
      refreshing: true 
    });
    
    const token = wx.getStorageSync('token');
    
    wx.request({
      url: app.globalData.BaseUrl + '/getActiveCounselor',
      method: 'GET',
      header: {
        'token': token,
        'Content-Type': 'application/json'
      },
      success: (res) => {
        if (res.statusCode === 200 && res.data.data && Array.isArray(res.data.data)) {
          // 更新本地存储和页面数据
          wx.setStorageSync('counselors', res.data.data);
          this.setData({
            counselors: res.data.data.map(item => ({
              id: item.id || '',
              name: item.name || '未知咨询师',
            })),
            loading: false,
            error: null,
            refreshing: false
          });
        } else {
          this.handleError(res.data?.msg || '获取咨询师列表失败');
        }
      },
      fail: (err) => {
        this.handleError('网络请求失败');
      }
    });
  },

  handleError: function(message) {
    this.setData({
      error: message,
      loading: false,
      refreshing: false
    });
    wx.showToast({
      title: message,
      icon: 'none',
      duration: 2000
    });
  },

  selectCounselor: function(e) {
    const counselor = e.currentTarget.dataset.counselor;
    wx.setStorageSync('selectedCounselor', counselor);
    wx.navigateTo({
      url: '/pages/Chatpage/Chatpage'
    });
  },

  onPullDownRefresh: function() {
    this.fetchCounselors();
  },

  // 新增重试方法
  retryFetch: function() {
    this.fetchCounselors();
  },
  goBackMainPage() {
    wx.reLaunch({
      url: '/pages/MainPage/MainPage'  // 替换成你的 MainPage 路径
    });
  }
});