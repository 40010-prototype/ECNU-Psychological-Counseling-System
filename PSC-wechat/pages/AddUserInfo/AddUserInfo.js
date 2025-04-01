Page({
  data: {
    name: '',
    phone: '',
    gender: 'male',
    age: '',
    emergencyContact: '',
    emergencyPhone: '',
    isSubmitting: false,
    isFormValid: false
  },

  // 处理姓名输入
  handleNameInput(e) {
    this.setData({ name: e.detail.value });
    this.validateForm();
  },

  // 处理电话输入
  handlePhoneInput(e) {
    this.setData({ phone: e.detail.value });
    this.validateForm();
  },

  // 处理性别选择
  handleGenderChange(e) {
    this.setData({ gender: e.detail.value });
    this.validateForm();
  },

  // 处理年龄输入
  handleAgeInput(e) {
    this.setData({ age: e.detail.value });
    this.validateForm();
  },

  // 处理紧急联系人输入
  handleEmergencyContactInput(e) {
    this.setData({ emergencyContact: e.detail.value });
    this.validateForm();
  },

  // 处理紧急联系电话输入
  handleEmergencyPhoneInput(e) {
    this.setData({ emergencyPhone: e.detail.value });
    this.validateForm();
  },

  // 验证表单
  validateForm() {
    const { name, phone, age, emergencyContact, emergencyPhone } = this.data;
    const isNameValid = name.length >= 2;
    const isPhoneValid = /^1[3-9]\d{9}$/.test(phone);
    const isAgeValid = age > 0 && age < 120;
    const isEmergencyContactValid = emergencyContact.length >= 2;
    const isEmergencyPhoneValid = /^1[3-9]\d{9}$/.test(emergencyPhone);

    this.setData({
      isFormValid: isNameValid && isPhoneValid && isAgeValid && 
                  isEmergencyContactValid && isEmergencyPhoneValid
    });
  },

  // 提交表单
  async handleSubmit() {
    if (!this.data.isFormValid || this.data.isSubmitting) return;

    this.setData({ isSubmitting: true });

    try {
      const res = await new Promise((resolve, reject) => {
        wx.request({
          url: 'http://127.0.0.1:4523/m1/6011225-5700055-default', // 替换为您的实际API端点
          method: 'POST',
          header: {
            'Authorization': `Bearer ${wx.getStorageSync('token')}`
          },
          data: {
            name: this.data.name,
            phone: this.data.phone,
            gender: this.data.gender,
            age: parseInt(this.data.age),
            emergencyContact: this.data.emergencyContact,
            emergencyPhone: this.data.emergencyPhone
          },
          success: resolve,
          fail: reject
        });
      });

      if (res.data.code === 200) {
        wx.showToast({
          title: '提交成功',
          icon: 'success'
        });
        
        // 延迟跳转到主页
        setTimeout(() => {
          wx.reLaunch({
            url: '/pages/MainPage/MainPage'
          });
        }, 1500);
      } else {
        throw new Error(res.data.msg || '提交失败');
      }
    } catch (error) {
      wx.showToast({
        title: error.message || '提交失败',
        icon: 'none'
      });
    } finally {
      this.setData({ isSubmitting: false });
    }
  }
}); 